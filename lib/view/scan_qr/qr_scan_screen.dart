import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_scanner/core/widget/button/standart_button.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:qr_scanner/core/extension/context_extension.dart';
import 'scan_qr_history.dart';
import 'show_scan_deatils.dart';

class QrScanScreen extends StatefulWidget {
  QrScanScreen({key}) : super(key: key);

  @override
  _QrScanScreenState createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final TextEditingController _outputController = TextEditingController();
  final GlobalKey key = GlobalKey<ScaffoldState>();

  String? barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        backgroundColor: Color(0xff1D1F22),
        body: SingleChildScrollView(
          child: Padding(
            padding: context.paddingMedium,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.asset(
                      'assets/asa.png',
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                  ],
                ),
                _buildOutTextField(),
                SizedBox(
                  height: 20,
                ),
                StandartButton(
                    title: 'SCAN QR',
                    onTap: () {
                      _scan();
                    }),
              ],
            ),
          ),
        ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: Text(
        'Scan QR',
        style: TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          alignment: Alignment.center,
          padding: EdgeInsets.only(),
          tooltip: 'History',
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ScanQrHistory()));
          },
          icon: Icon(
            Icons.restore,
            color: Colors.white,
            size: 30,
          ),
        ),
      ],
      backgroundColor: Colors.transparent,
    );
  }

  Future _scan() async {
    await Permission.camera.request();
    barcode = await scanner.scan();
    if (barcode == null) {
      print('Nothing return.');
    } else {
      setState(() async {
        _outputController.text = barcode!;
        setState(() {});
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowDeatilsScan(_outputController.text)));
      });
    }
  }

  Widget _buildOutTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: _outputController,
        maxLines: 1,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          suffixIcon: Column(
            children: [
              IconButton(
                tooltip: 'Details',
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () async {
                  if (_outputController.text.isNotEmpty &&
                      _outputController.text.isNotEmpty) {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ShowDeatilsScan(_outputController.text)));
                  } else {
                    showAlertDialog(context);
                  }
                },
              ),
            ],
          ),
          prefixIcon: Icon(
            Icons.qr_code,
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(5),
          ),
          hintText: 'Your Code will be Here.',
          hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = Text('OK');

    // set up the AlertDialog
    var alert = AlertDialog(
      title: Text('Scan'),
      content: Text('Scan QR And Be HAPPY'),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
