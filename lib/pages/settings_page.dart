import 'package:flutter/material.dart';

import '../classes/config.dart';

final Config config = Config();

const TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  static late TextEditingController hostAddressController;
  String _hostAddress = '';

  void updateHostAddress(String value) {
    setState(() => _hostAddress = value.trim());
    config.hostAddress = value.trim();
  }

  @override
  void initState() {
    super.initState();
    // Populate the Access Token variable
    _hostAddress = config.hostAddress;

    // Then populate the input field with the value
    hostAddressController = TextEditingController(text: _hostAddress);
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
            'Remote Device Host Address:',
            style: boldStyle,
          ),
          const SizedBox(height: 10),
          TextField(
            autofocus: true,
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
              'to the remote device over the local network.')
        ]),
      ),
    );
  }
}
