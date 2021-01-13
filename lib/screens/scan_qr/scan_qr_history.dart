import 'package:flutter/material.dart';

class ScanQrHistory extends StatefulWidget {
  ScanQrHistory({Key key}) : super(key: key);

  @override
  _ScanQrHistoryState createState() => _ScanQrHistoryState();
}

class _ScanQrHistoryState extends State<ScanQrHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1D1F22),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Scan Qr History',
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
