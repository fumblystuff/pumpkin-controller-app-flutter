import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../classes/config.dart';

const TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);

final Config config = Config();
ConnectionMethod? _connection;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  static late TextEditingController hostAddressController;
  static late TextEditingController broadcastPrefixController;

  String _hostAddress = '';
  String _broadcastPrefix = 'pumpkin';

  void updateHostAddress(String value) {
    setState(() => _hostAddress = value.trim());
    config.hostAddress = value.trim();
  }

  void updateBroadcastPrefix(String value) {
    setState(() => _broadcastPrefix = value.trim());
    config.broadcastPrefix = value.trim();
  }

  void updateConnectionMethod(ConnectionMethod connection) {
    setState(() => _connection = connection);
    config.connectionMethod = connection;
  }

  @override
  void initState() {
    super.initState();
    _broadcastPrefix = config.broadcastPrefix;
    _hostAddress = config.hostAddress;
    _connection = config.connectionMethod;

    // Populate the text fields
    hostAddressController = TextEditingController(text: _hostAddress);
    broadcastPrefixController = TextEditingController(text: _broadcastPrefix);
  }

  @override
  void dispose() {
    hostAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(12.0), children: [
          const Text(
            'Connection Type',
            style: boldStyle,
          ),
          Column(
            children: [
              RadioListTile<ConnectionMethod>(
                title: const Text('HTTP (Web Server)'),
                value: ConnectionMethod.http,
                groupValue: _connection,
                onChanged: (ConnectionMethod? value) {
                  updateConnectionMethod(value!);
                },
              ),
              Visibility(
                // hide this on the web as it's not a valid option
                visible: !kIsWeb,
                child: RadioListTile<ConnectionMethod>(
                  title: const Text('UDP (Experimental, do not use!)'),
                  value: ConnectionMethod.udp,
                  groupValue: _connection,
                  onChanged: (ConnectionMethod? value) {
                    updateConnectionMethod(value!);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Remote Device Host Address:',
            style: boldStyle,
          ),
          const SizedBox(height: 10),
          TextField(
            autofocus: true,
            enabled: _connection == ConnectionMethod.http,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: updateHostAddress,
            controller: hostAddressController,
            style: const TextStyle(fontFamily: 'Roboto Mono', fontSize: 15),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
          const SizedBox(height: 20),
          const Text('The application uses the host address to connect '
              'to the remote device over the local network.'),
          const SizedBox(height: 20),
          Visibility(
            // Hide this if we're on the web
            visible: !kIsWeb,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'UDP Broadcast Prefix:',
                  style: boldStyle,
                ),
                const SizedBox(height: 10),
                TextField(
                  autofocus: true,
                  enabled: _connection == ConnectionMethod.udp,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: updateBroadcastPrefix,
                  controller: broadcastPrefixController,
                  // style: const TextStyle(fontFamily: 'Roboto Mono', fontSize: 15),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                const SizedBox(height: 20),
                const Text(
                    'Appended to UDP broadcast messages sent on the local network (subnet).'),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
