import 'package:flutter/material.dart';

import '../constants.dart';
import 'about_page.dart';
import 'settings_page.dart';

class PumpkinControllerHome extends StatefulWidget {
  const PumpkinControllerHome({super.key, required this.title});

  final String title;

  @override
  State<PumpkinControllerHome> createState() => _PumpkinControllerHomeState();
}

class _PumpkinControllerHomeState extends State<PumpkinControllerHome> {
  @override
  Widget build(BuildContext context) {
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
                MaterialPageRoute(builder: (context) => const AboutPage()),
              ).then((value) => {log.info("returned")});
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              log.info('Opening Settings page');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              ).then((value) => {log.info("returned")});
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage('assets/images/pumpkin-256.png')),
          ],
        ),
      ),
    );
  }
}
