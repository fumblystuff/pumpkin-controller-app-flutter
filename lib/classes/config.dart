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
  final broadcastPrefixKey = 'BroadcastPrefix';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _hostAddress = '';
  String _broadcastPrefix = '';

  Config._internal() {
    log.fine('Config: _internal()');
  }

  Future loadData() async {
    // log.info('Config: loadData()');
    // uncomment the following code to simulate a delay in loading the config
    // so you can see the loading message longer
    // await Future.delayed(const Duration(seconds: 4), () {});
    final SharedPreferences prefs = await _prefs;

    _hostAddress = prefs.getString(hostAddressKey) ?? '';
    _broadcastPrefix = prefs.getString(broadcastPrefixKey) ?? '';
  }

  String get hostAddress {
    return _hostAddress;
  }

  set hostAddress(String hostAddress) {
    _hostAddress = hostAddress;
    _saveString(hostAddressKey, hostAddress);
  }

  String get broadcastPrefix {
    return _broadcastPrefix;
  }

  set broadcastPrefix(String broadcastPrefix) {
    _broadcastPrefix = broadcastPrefix;
    _saveString(broadcastPrefixKey, broadcastPrefix);
  }

  _saveString(String key, String value, {bool hideValue = false}) async {
    // Show asterisks or the actual value? Generates string made up of
    // asterisks equaling the length of the original string
    String printVal = hideValue ? '*' * value.length : value;
    // log.info('Config: Writing "$printVal" to preferences "$key"');
    final SharedPreferences prefs = await _prefs;
    prefs.setString(key, value);
  }
}
