import 'package:flutter/material.dart';

import '../classes/config.dart';

enum ConnectionMethod { http, udp }

const TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);

final Config config = Config();
ConnectionMethod? _connection;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
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

  @override
  void initState() {
    super.initState();
    // Populate the Access Token variable
    _hostAddress = config.hostAddress;
    _connection = ConnectionMethod.http;
    // Then populate the input field with the value
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
                  setState(() {
                    _connection = value;
                  });
                },
              ),
              RadioListTile<ConnectionMethod>(
                title: const Text('UDP (Experimental, do not use!)'),
                value: ConnectionMethod.udp,
                groupValue: _connection,
                onChanged: (ConnectionMethod? value) {
                  setState(() {
                    _connection = value;
                  });
                },
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
          const Text('Appended to UDP broadcast messages sent on the network.')
        ]),
      ),
    );
  }
}
