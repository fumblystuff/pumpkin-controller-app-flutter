import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../classes/config.dart';
import '../constants.dart';
import '../utils/alerts.dart';
import 'about_page.dart';
import 'settings_page.dart';

//https://api.flutter.dev/flutter/material/DropdownMenu-class.html
enum FlashCount {
  one('One', 1),
  two('Two', 2),
  three('Three', 3),
  four('Four', 4),
  five('Five', 5);

  const FlashCount(this.label, this.count);
  final String label;
  final int count;
}

final Alerts alerts = Alerts(); // Alert functions
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
  final TextEditingController flashController = TextEditingController();

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
    final List<DropdownMenuEntry<FlashCount>> countEntries =
        <DropdownMenuEntry<FlashCount>>[];
    for (final FlashCount color in FlashCount.values) {
      countEntries.add(
        DropdownMenuEntry<FlashCount>(value: color, label: color.label),
      );
    }
    FlashCount? selectedCount;

    double boxWidth = 10;

    TextStyle headingStyle =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

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
              body: Container(
                constraints: const BoxConstraints(minWidth: 400, maxWidth: 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          _expandedButton(
                              context: context, btnText: 'All Off', cmd: 'off')
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          _expandedButton(
                              context: context,
                              btnText: 'Random',
                              cmd: 'random'),
                          SizedBox(width: boxWidth),
                          _expandedButton(
                              context: context,
                              btnText: 'Lightning',
                              cmd: 'lightning'),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Static Colors',
                          style: headingStyle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          _expandedButton(
                              context: context,
                              btnText: 'Blue',
                              cmd: 'color:0',
                              btnColor: Colors.blue,
                              textColor: Colors.white),
                          SizedBox(width: boxWidth),
                          _expandedButton(
                              context: context,
                              btnText: 'Green',
                              cmd: 'color:1',
                              btnColor: Colors.green,
                              textColor: Colors.white),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          _expandedButton(
                              context: context,
                              btnText: 'Orange',
                              cmd: 'color:2',
                              btnColor: Colors.orange,
                              textColor: Colors.black),
                          SizedBox(width: boxWidth),
                          _expandedButton(
                              context: context,
                              btnText: 'Purple',
                              cmd: 'color:3',
                              btnColor: Colors.purple,
                              textColor: Colors.white),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          _expandedButton(
                              context: context,
                              btnText: 'Red',
                              cmd: 'color:4',
                              btnColor: Colors.red,
                              textColor: Colors.white),
                          SizedBox(width: boxWidth),
                          _expandedButton(
                              context: context,
                              btnText: 'Yellow',
                              cmd: 'color:5',
                              btnColor: Colors.yellow,
                              textColor: Colors.black),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Flash',
                          style: headingStyle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const Text('Number of flashes:'),
                          SizedBox(width: boxWidth),
                          DropdownMenu<FlashCount>(
                            initialSelection: FlashCount.three,
                            controller: flashController,
                            dropdownMenuEntries: countEntries,
                            onSelected: (FlashCount? sel) {
                              log.info('Flash count selection: ${sel?.count}');
                              setState(() {
                                selectedCount = sel;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          _expandedButton(
                              context: context,
                              btnText: 'Blue',
                              cmd: 'flash:0:${selectedCount?.count}',
                              btnColor: Colors.blue,
                              textColor: Colors.white),
                          SizedBox(width: boxWidth),
                          _expandedButton(
                              context: context,
                              btnText: 'Green',
                              cmd: 'flash:1:${selectedCount?.count}',
                              btnColor: Colors.green,
                              textColor: Colors.white),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          _expandedButton(
                              context: context,
                              btnText: 'Orange',
                              cmd: 'flash:2:${selectedCount?.count}',
                              btnColor: Colors.orange,
                              textColor: Colors.black),
                          SizedBox(width: boxWidth),
                          _expandedButton(
                              context: context,
                              btnText: 'Purple',
                              cmd: 'flash:3:${selectedCount?.count}',
                              btnColor: Colors.purple,
                              textColor: Colors.white),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          _expandedButton(
                              context: context,
                              btnText: 'Red',
                              cmd: 'flash:4:${selectedCount?.count}',
                              btnColor: Colors.red,
                              textColor: Colors.white),
                          SizedBox(width: boxWidth),
                          _expandedButton(
                              context: context,
                              btnText: 'Yellow',
                              cmd: 'flash:5:${selectedCount?.count}',
                              btnColor: Colors.yellow,
                              textColor: Colors.black),
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

void execCmd(BuildContext context, String cmdSnippet) async {
  Response response;
  String cmdStr = 'http://${config.hostAddress}/$cmdSnippet';
  log.info('Connecting to $cmdStr');
  try {
    response = await dio.get(cmdStr);
    if (response.statusCode == 200) {
      log.info('Success');
      Fluttertoast.showToast(
          msg: 'Successfully executed "$cmdSnippet" command',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    } else {
      log.info('Failure ${response.statusMessage}');
      if (!context.mounted) return;
      alerts.alertRaisedWait(
          context: context,
          title: 'Error',
          message: 'Remote command execution failed (unknown error)');
    }
  } on DioException catch (e) {
    if (e.response != null) {
      print(e.response?.data);
      print(e.response?.headers);

      if (!context.mounted) return;
      alerts.alertRaisedWait(
          context: context,
          title: 'Execution Error',
          message: e.response!.statusMessage ?? 'Failure');
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      log.info(e.requestOptions);
      log.info(e.message);
    }
  }
}

Widget _expandedButton(
    {required BuildContext context,
    required String btnText,
    required String cmd,
    Color btnColor = const Color(0xFFfefbff),
    Color textColor = const Color(0xFF005ac2)}) {
  // create our custom style object
  ButtonStyle style = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      textStyle: const TextStyle(fontSize: 20),
      backgroundColor: btnColor,
      foregroundColor: textColor);
  return Expanded(
    child: ElevatedButton(
      onPressed: () {
        log.info('Button "$btnText" clicked');
        execCmd(context, cmd);
      },
      style: style,
      child: Text(btnText),
    ),
  );
}
