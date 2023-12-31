import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:udp/udp.dart';

import '../classes/config.dart';
import '../constants.dart';
import '../utils/alerts.dart';
import 'about_page.dart';
import 'settings_page.dart';

//https://api.flutter.dev/flutter/material/DropdownMenu-class.html
enum FlashCount {
  solid('Solid (no flash)', 0),
  one('Flash Once', 1),
  two('Flash Twice', 2),
  three('Flash Three Times', 3),
  four('Flash Four Times', 4),
  five('Flash Five Times', 5);

  const FlashCount(this.label, this.count);
  final String label;
  final int count;
}

late FlashCount? selectedCount;
// https://stackoverflow.com/questions/57793479/flutter-futurebuilder-gets-constantly-called
late Future initFuture;

const configErrorStr = 'Configuration Error';
final Alerts alerts = Alerts(); // Alert functions
final Config config = Config();
final dio = Dio();

class PumpkinControllerHome extends StatefulWidget {
  const PumpkinControllerHome({super.key, required this.title});
  final String title;

  @override
  State<PumpkinControllerHome> createState() => _PumpkinControllerHomeState();
}

class _PumpkinControllerHomeState extends State<PumpkinControllerHome> {
  final TextEditingController flashController = TextEditingController();

  // Initialize the Config class (loading data) for the FutureBuilder
  Future<bool> initializeApp() async {
    log.info('HomePage: loadConfigAsync()');
    // Initialize the config object
    await config.loadData();
    // Tell FutureBuilder we're ready to go...
    return true;
  }

  @override
  void initState() {
    log.info('HomePage: Initializing State');
    super.initState();
    initFuture = initializeApp();
    selectedCount = FlashCount.solid;
  }

  @override
  Widget build(BuildContext context) {
    double boxWidth = 10;
    TextStyle headingStyle =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
    ButtonStyle btnStyle = ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        textStyle: const TextStyle(fontSize: 20));

    final List<DropdownMenuEntry<FlashCount>> countEntries =
        <DropdownMenuEntry<FlashCount>>[];
    for (final FlashCount color in FlashCount.values) {
      countEntries.add(
        DropdownMenuEntry<FlashCount>(value: color, label: color.label),
      );
    }

    return FutureBuilder(
        future: initFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Then display our app's main screen
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
                        MaterialPageRoute(
                            builder: (context) => const AboutPage()),
                      ).then((value) => {log.info("returned")});
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      log.info('Opening Settings page');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()),
                      ).then((value) => {log.info("returned")});
                    },
                  ),
                ],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    constraints:
                        const BoxConstraints(minWidth: 400, maxWidth: 600),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: ElevatedButton.icon(
                                  label: const Text('All Off'),
                                  icon: const Icon(Icons.highlight_off),
                                  onPressed: () {
                                    execCmd(context, 'off');
                                  },
                                  style: btnStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: ElevatedButton.icon(
                                  label: const Text('Random'),
                                  icon: const Icon(Icons.shuffle),
                                  onPressed: () {
                                    execCmd(context, 'random');
                                  },
                                  style: btnStyle,
                                ),
                              ),
                              SizedBox(width: boxWidth),
                              Expanded(
                                child: ElevatedButton(
                                  // icon: const Icon(Icons.bolt),
                                  onPressed: () {
                                    execCmd(context, 'lightning');
                                  },
                                  style: btnStyle,
                                  child: const Text('Lightning'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Colors',
                                    style: headingStyle,
                                  ),
                                ),
                              ),
                              DropdownMenu<FlashCount>(
                                initialSelection: FlashCount.solid,
                                controller: flashController,
                                dropdownMenuEntries: countEntries,
                                onSelected: (FlashCount? sel) {
                                  // log.info('Flash count selection: ${sel?.count}');
                                  setState(() {
                                    selectedCount = sel;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              _expandedButton(
                                  context: context,
                                  btnText: 'Blue',
                                  colorIdx: 0,
                                  countIdx: selectedCount!.count,
                                  btnColor: Colors.blue,
                                  textColor: Colors.white),
                              SizedBox(width: boxWidth),
                              _expandedButton(
                                  context: context,
                                  btnText: 'Green',
                                  colorIdx: 1,
                                  countIdx: selectedCount!.count,
                                  btnColor: Colors.green,
                                  textColor: Colors.white),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              _expandedButton(
                                  context: context,
                                  btnText: 'Orange',
                                  colorIdx: 2,
                                  countIdx: selectedCount!.count,
                                  btnColor: Colors.orange,
                                  textColor: Colors.black),
                              SizedBox(width: boxWidth),
                              _expandedButton(
                                  context: context,
                                  btnText: 'Purple',
                                  colorIdx: 3,
                                  countIdx: selectedCount!.count,
                                  btnColor: Colors.purple,
                                  textColor: Colors.white),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              _expandedButton(
                                  context: context,
                                  btnText: 'Red',
                                  colorIdx: 4,
                                  countIdx: selectedCount!.count,
                                  btnColor: Colors.red,
                                  textColor: Colors.white),
                              SizedBox(width: boxWidth),
                              _expandedButton(
                                  context: context,
                                  btnText: 'Yellow',
                                  colorIdx: 5,
                                  countIdx: selectedCount!.count,
                                  btnColor: Colors.yellow,
                                  textColor: Colors.black),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            // Display the loading pumpkin
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(image: AssetImage('assets/images/pumpkin-256.png')),
                  ],
                ),
              ),
            );
          } // if (!snapshot.hasData)
        });
  }
}

Widget _expandedButton(
    {required BuildContext context,
    required String btnText,
    required int colorIdx,
    required int countIdx,
    Color btnColor = const Color(0xFFfefbff),
    Color textColor = const Color(0xFF005ac2)}) {
  // create our custom btnStyle object
  ButtonStyle btnStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      textStyle: const TextStyle(fontSize: 20),
      backgroundColor: btnColor,
      foregroundColor: textColor);

  String cmd = (countIdx < 1) ? 'color:$colorIdx' : 'flash:$colorIdx:$countIdx';
  return Expanded(
    child: ElevatedButton(
      onPressed: () {
        // log.info('Button "$btnText" clicked');
        execCmd(context, cmd);
      },
      style: btnStyle,
      child: Text(btnText),
    ),
  );
}

void execCmd(BuildContext context, String cmdSnippet) async {
  if (config.connectionMethod == ConnectionMethod.http) {
    String hostAddress = config.hostAddress;
    if (hostAddress.isEmpty) {
      alerts.alertRaisedWait(
          context: context,
          title: configErrorStr,
          message: 'You must enter an IP Address for the remote device'
              'before you can send commands to it.\nOpen the '
              'Settings page (click the gear icon in the upper right'
              'corner of the app) and enter the IP address.');
      return;
    }
    sendHTTPCommand(context, 'http://$hostAddress/$cmdSnippet');
  } else {
    String broadcastPrefix = config.broadcastPrefix;
    if (broadcastPrefix.isEmpty) {
      alerts.alertRaisedWait(
          context: context,
          title: configErrorStr,
          message: 'You must enter a broadcast prefix in the app '
              'configuration.\nOpen the Settings page (click the '
              'gear icon in the upper right corner of the app) '
              'and update the broadcast prefix.');
      return;
    }
    sendUDPBroadcast(context, '$broadcastPrefix::$cmdSnippet');
  }
}

void sendHTTPCommand(BuildContext context, String cmdStr) async {
  Response response;
  log.info('Connecting to $cmdStr');
  try {
    EasyLoading.show(status: 'Executing...');
    response = await dio.get(cmdStr);
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      log.info('Success');
      Fluttertoast.showToast(
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    } else {
      log.info('Failure ${response.statusMessage}');
      if (!context.mounted) return;
      alerts.alertRaisedWait(
          context: context,
          title: 'Error',
          message: 'Remote command execution failed (unknown error)');
    }
  } on DioException catch (e) {
    log.severe('Dio Exception');
    EasyLoading.dismiss();
    if (e.response != null) {
      print(e.response?.data);
      print(e.response?.headers);
      if (!context.mounted) return;
      alerts.alertRaisedWait(
          context: context,
          title: 'Execution Error',
          message: e.response!.statusMessage ?? 'Failure');
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      log.severe(e.error);
      if (!context.mounted) return;
      alerts.alertRaisedWait(
          context: context,
          title: 'Dio Library Exception',
          message: e.error.toString() ?? 'Failure');
    }
  }
}

void sendUDPBroadcast(BuildContext context, String cmdStr) async {
  // https://pub.dev/packages/udp
  // creates a UDP instance and binds it to the first available network
  // interface on port 65000.
  var sender = await UDP.bind(Endpoint.any(port: const Port(udpPort)));
  // creates a new UDP instance and binds it to the local address and the
  // uspPort (constants.dart).  Creating this early so its available when
  // the app sends.
  // var receiver = await UDP.bind(Endpoint.loopback(port: const Port(65002)));
  var receiver = await UDP.bind(Endpoint.any());

  // send a simple string to a broadcast endpoint on port udpBroadcastPort
  // (from constants.dart).
  var dataLength = await sender.send(
      cmdStr.codeUnits, Endpoint.broadcast(port: const Port(udpBroadcastPort)));
  log.info("Broadcasting $cmdStr ($dataLength bytes)");

  receiver.asStream(timeout: const Duration(seconds: 10)).listen((datagram) {
    var str = String.fromCharCodes(datagram!.data);
    log.info(str);
  });
  // close the UDP instances and their sockets.
  receiver.close();
  sender.close();
}
