import 'package:flutter/material.dart';

class Alerts {
  void alertElevated(BuildContext context, String title, String message,
      {String btnText = 'OK'}) {
    Widget okButton = ElevatedButton(
        onPressed: () {
          print('Alerts.alertRaised: "$btnText" tapped');
          Navigator.of(context).pop();
        },
        child: Text(btnText));

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [okButton],
    );

    showDialog(
      context: context,
      barrierDismissible: false, // user must tap a button to close the dialog
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Not tested
  // void yesNoElevated(BuildContext context, String title, String message) {
  //   Widget buttonYes = ElevatedButton(
  //       onPressed: () {
  //         print('Alerts.alertRaised: Yes tapped');
  //         Navigator.of(context).pop();
  //       },
  //       child: Text('Yes'));
  //
  //   Widget buttonNo = ElevatedButton(
  //       onPressed: () {
  //         print('Alerts.alertRaised: No tapped');
  //         Navigator.of(context).pop();
  //       },
  //       child: Text("No"));
  //
  //   AlertDialog alert = AlertDialog(
  //     title: Text(title),
  //     content: Text(message),
  //     actions: [buttonYes, buttonNo],
  //   );
  //
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, // user must tap a button to close the dialog
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  void alertText(BuildContext context, String title, String message,
      {String btnText = 'OK'}) {
    Widget okButton = TextButton(
      child: Text(btnText),
      onPressed: () {
        print('Alerts.alertRaised: "$btnText" tapped');
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [okButton],
    );

    showDialog(
      context: context,
      barrierDismissible: false, // user must tap a button to close the dialog
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> alertRaisedWait(
      {required BuildContext context,
      required String title,
      required String message,
      String btnText = 'OK'}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap a button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: Text(btnText),
              onPressed: () {
                print('Alerts.alertRaisedWait: "$btnText" tapped');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> alertFlatWait(BuildContext context, String title, String message,
      {String btnText = 'OK'}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap a button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(btnText),
              onPressed: () {
                print('Alerts.alertRaisedWait: "$btnText" tapped');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
