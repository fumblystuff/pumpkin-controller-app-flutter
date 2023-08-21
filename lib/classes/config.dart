/*
* Config Class
*
* Manages the app's configuration settings
* Writes data to local storage using the `shared_preferences` package
*
* */
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class Config with ChangeNotifier {
  static final Config _config = Config._internal();

  factory Config() => _config;

  final hostAddressKey = 'HostAddress';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _hostAddress = '';

  Config._internal() {
    log.fine('Config: _internal()');
  }

  Future loadData() async {
    log.info('Config: loadData()');
    // uncomment the following code to simulate a delay in loading the config
    // so you can see the loading message longer
    // await Future.delayed(const Duration(seconds: 4), () {});
    final SharedPreferences prefs = await _prefs;

    _hostAddress = prefs.getString(hostAddressKey) ?? '';
    log.info('Config: Data loaded');
  }

  String get hostAddress {
    log.fine('Config: Get hostAddress');
    return _hostAddress;
  }

  set hostAddress(String hostAddress) {
    log.fine('Config: Set host address ($hostAddress)');
    _hostAddress = hostAddress;
    _saveString(hostAddressKey, hostAddress);
  }

  _saveString(String key, String value, {bool hideValue = false}) async {
    // Show asterisks or the actual value? Generates string made up of
    // asterisks equaling the length of the original string
    String printVal = hideValue ? '*' * value.length : value;
    log.info('Config: Writing "$printVal" to preferences "$key"');
    final SharedPreferences prefs = await _prefs;
    prefs.setString(key, value);
  }
}
