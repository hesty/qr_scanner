import 'package:flutter/material.dart';

class ShowAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  ShowAlertDialog({Key? key, required this.title, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 2,
      child: _alertDialog(context),
    );
  }

  AlertDialog _alertDialog(BuildContext context) {
    print('deneme');
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        _okButton(context),
      ],
    );
  }

  Widget _okButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('OK'),
    );
  }
}
