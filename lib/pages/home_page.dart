import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../classes/config.dart';
import '../constants.dart';
import 'about_page.dart';
import 'settings_page.dart';

final Config config = Config();
final dio = Dio();

// https://stackoverflow.com/questions/57793479/flutter-futurebuilder-gets-constantly-called
late Future initFuture;

class PumpkinControllerHome extends StatefulWidget {
  const PumpkinControllerHome({super.key, required this.title});
  final String title;

  @override
  State<PumpkinControllerHome> createState() => _PumpkinControllerHomeState();
}

class _PumpkinControllerHomeState extends State<PumpkinControllerHome> {
  // Initialize the Config class (loading data) for the FutureBuilder
  Future<bool> initializeApp() async {
    log.info('HomePage: loadConfigAsync()');
    // Initialize the config object
    await config.loadData();
    // Tell FutureBuilder we're ready to go...
    return true;
  }

  @override
  void initState() {
    log.info('HomePage: Initializing State');
    super.initState();
    initFuture = initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    double boxWidth = 10;
    final ButtonStyle style = ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        textStyle: const TextStyle(fontSize: 20));

    return FutureBuilder(
        future: initFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Then display our app's main screen
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widget.title),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () {
                      log.info('Opening About page');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutPage()),
                      ).then((value) => {log.info("returned")});
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      log.info('Opening Settings page');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()),
                      ).then((value) => {log.info("returned")});
                    },
                  ),
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              log.info('button clicked');
                              execCmd('off');
                            },
                            style: style,
                            child: const Text('All Off'),
                          ),
                          SizedBox(width: boxWidth),
                          ElevatedButton(
                            onPressed: () {
                              log.info('button clicked');
                              execCmd('random');
                            },
                            style: style,
                            child: const Text('Random'),
                          ),
                          SizedBox(width: boxWidth),
                          ElevatedButton(
                            onPressed: () {
                              log.info('button clicked');
                              execCmd('lightning');
                            },
                            style: style,
                            child: const Text('Lightning'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Display the loading pumpkin
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(image: AssetImage('assets/images/pumpkin-256.png')),
                  ],
                ),
              ),
            );
          } // if (!snapshot.hasData)
        });
  }
}

void execCmd(String cmdSnippet) async {
  String cmdStr = 'http://${config.hostAddress}/$cmdSnippet';
  log.info('Connecting to ${cmdStr}');
  final response = await dio.get(cmdStr);
  log.info(response.data);
}
