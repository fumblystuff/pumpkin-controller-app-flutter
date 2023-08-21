/*
 * About Page
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  _AboutPage createState() => _AboutPage();
}

class _AboutPage extends State<AboutPage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget appInfoStr(String title, String subtitle) {
    title += ": ";
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text.rich(TextSpan(children: [
        TextSpan(
            text: title, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: subtitle.isNotEmpty ? subtitle : 'Not set'),
      ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('About'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SafeArea(
            child: ListView(padding: const EdgeInsets.all(16.0), children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 2,
                  ),
                ),
                child: Image.asset("assets/images/pumpkin-128.png"),
              )
            ],
          ),
          const Text('Flank ground round bresaola salami. Ribeye short ribs '
              'pastrami pork chop jerky jowl picanha. Pork ham bacon '
              'pancetta tongue. Swine burgdoggen frankfurter cupim chuck '
              'porchetta. Shoulder ball tip meatloaf ham hock beef pig '
              'pastrami jowl boudin sirloin swine chuck chislic turkey.'),
          const SizedBox(height: 10),
          const Text("Chislic flank picanha pork pork loin landjaeger, tri-tip "
              "biltong porchetta jowl chuck hamburger shoulder tail salami. "
              "Burgdoggen pig ribeye pork salami andouille. Kevin salami "
              "sirloin tail. Meatloaf andouille tongue burgdoggen fatback, "
              "kielbasa short loin. Shoulder bresaola swine kielbasa, "
              "fatback ground round sausage turducken tri-tip hamburger "
              "pork venison bacon ball tip buffalo. Beef ribs fatback "
              "salami kevin."),
          const SizedBox(height: 20),
          const Text("Application Information",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          const Divider(thickness: 3),
          appInfoStr('Application name', _packageInfo.appName),
          appInfoStr('Package name', _packageInfo.packageName),
          appInfoStr('Application version', _packageInfo.version),
          appInfoStr('Build number', _packageInfo.buildNumber),
        ])));
  }
}
