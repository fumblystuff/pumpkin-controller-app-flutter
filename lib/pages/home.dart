import 'package:flutter/material.dart';

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
            icon: Icon(Icons.settings),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage('assets/images/pumpkin-256.png')),
            Text(
              'Loading configuration data...',
            ),
          ],
        ),
      ),
    );
  }
}
