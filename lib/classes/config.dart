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

enum ConnectionMethod { http, udp }

class Config with ChangeNotifier {
  static final Config _config = Config._internal();

  factory Config() => _config;

  final broadcastPrefixKey = 'BroadcastPrefix';
  final connectionMethodKey = 'ConnectionMethod';
  final hostAddressKey = 'HostAddress';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _hostAddress = '';
  String _broadcastPrefix = '';
  late ConnectionMethod _connectionMethod;

  Config._internal() {
    log.fine('Config: _internal()');
  }

  Future loadData() async {
    // uncomment the following code to simulate a delay in loading the config
    // so you can see the loading message longer
    // await Future.delayed(const Duration(seconds: 4), () {});
    final SharedPreferences prefs = await _prefs;

    _broadcastPrefix =
        prefs.getString(broadcastPrefixKey) ?? defaultBroadcastPrefix;
    int tempInt =
        prefs.getInt(connectionMethodKey) ?? ConnectionMethod.http.index;
    _connectionMethod = ConnectionMethod.values[tempInt];
    _hostAddress = prefs.getString(hostAddressKey) ?? '';
  }

  String get broadcastPrefix {
    return _broadcastPrefix;
  }

  set broadcastPrefix(String broadcastPrefix) {
    _broadcastPrefix = broadcastPrefix;
    _saveString(broadcastPrefixKey, broadcastPrefix);
  }

  ConnectionMethod get connectionMethod {
    return _connectionMethod;
  }

  set connectionMethod(ConnectionMethod connectionMethod) {
    _connectionMethod = connectionMethod;
    _saveInt(connectionMethodKey, connectionMethod.index);
  }

  String get hostAddress {
    return _hostAddress;
  }

  set hostAddress(String hostAddress) {
    _hostAddress = hostAddress;
    _saveString(hostAddressKey, hostAddress);
  }

  _saveString(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(key, value);
  }

  _saveInt(String key, int value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt(key, value);
  }
}
