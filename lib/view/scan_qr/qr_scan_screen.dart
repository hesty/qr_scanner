import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_scanner/view/_product/widget/normal_sized_box.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../../core/extension/context_extension.dart';
import '../../core/widget/button/standart_button.dart';
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
        body: SingleChildScrollView(
            padding: context.paddingMedium,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.asset(
                      'assets/asa.png',
                      height: context.height * 0.4,
                    ),
                  ],
                ),
                NormalSizedBox(),
                _buildOutTextField(),
                NormalSizedBox(),
                StandartButton(
                    title: 'SCAN QR',
                    onTap: () {
                      _scan();
                    }),
              ],
            )));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Scan QR',
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

  Future<void> _scan() async {
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
    return TextFormField(
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
                  //showAlertDialog(context);
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
        hintText: 'Result will be here.',
        hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}
