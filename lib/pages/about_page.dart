/*
 * About Page
 */

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchUrl(String target) async {
    Uri url = Uri.parse(target);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget appInfoStr(String title, String subtitle) {
    title += ": ";
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(
              text: title, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: subtitle.isNotEmpty ? subtitle : 'Not set'),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle linkStyle = const TextStyle(color: Colors.blue);

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
              Image.asset("assets/images/pumpkin-128.png"),
            ],
          ),
          const Text(''),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'This is the controller application for the ',
                ),
                TextSpan(
                  text: 'Glowing Pumpkin Xiao 5x5 BFF Server',
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchUrl(
                          'https://github.com/johnwargo/glowing-pumpkin-xiao-bff-server');
                    },
                ),
                const TextSpan(
                    text: ' project. It allows you to remotely control a 5x5 '
                        'array of LEDs (NeoPioxels) attached to a Seeed '
                        'Studio Xaio device. Refer to the project link '
                        'for additional details.\n'),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Project and App by ',
                ),
                TextSpan(
                  text: 'John M. Wargo',
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchUrl('https://johnwargo.com');
                    },
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text("Application Information",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          const Divider(thickness: 3),
          appInfoStr('Application name', _packageInfo.appName),
          appInfoStr('Package name', _packageInfo.packageName),
          appInfoStr('Application version', _packageInfo.version),
          appInfoStr('Build number', _packageInfo.buildNumber),
        ]),
      ),
    );
  }
}
