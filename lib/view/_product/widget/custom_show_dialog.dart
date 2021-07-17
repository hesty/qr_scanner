import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:qr_scanner/core/widget/dialog/custom_dialog.dart';

class CustomShowDialog {
  static Future<void> showSuccesDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: 'Successful',
        subTitle: 'QR photo saved.',
        icon: Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        actionWidget: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: AutoSizeText(
                  'OK',
                  style: TextStyle(color: Color(0xff325CFD)),
                )),
          ],
        ),
      ),
    );
  }

  static Future<void> showAlertCreateQr(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: 'Warning',
        titleStyle: TextStyle(color: Colors.red),
        subTitle: 'Please genereate qr.',
        icon: Icon(
          Icons.warning,
          color: Colors.red,
        ),
        actionWidget: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: AutoSizeText(
                  'OK',
                  style: TextStyle(color: Colors.red),
                )),
          ],
        ),
      ),
    );
  }
}
