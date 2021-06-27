import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_scanner/core/utils/db_helper.dart';
import 'package:qr_scanner/core/widget/button/standart_button.dart';
import 'package:qr_scanner/core/widget/card/standart_card.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:qr_scanner/core/extension/context_extension.dart';
import '../../models/generate_history_model.dart';

class QrGenerateUrl extends StatefulWidget {
  QrGenerateUrl({key}) : super(key: key);

  @override
  _QrGenerateScreenState createState() => _QrGenerateScreenState();
}

class _QrGenerateScreenState extends State<QrGenerateUrl>
    with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List allHistory = <GenerateHistoryModel>[];
  Uint8List bytes = Uint8List(0);

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1D1F22),
      body: _buildBody(),
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: _inputController,
      maxLines: 1,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.link,
          color: Colors.white,
        ),
        suffixIcon: IconButton(
          tooltip: 'Paste to ClipBoard',
          icon: Icon(
            Icons.paste,
            color: Colors.white,
          ),
          onPressed: () async {
            var data = await Clipboard.getData('text/plain');
            setState(() {
              _inputController.text = data!.text.toString();
            });
          },
        ),
        hintText: 'http://www.example.com',
      ),
    );
  }

  Widget _buildGenerateButton() {
    return StandartButton(
        title: 'GENERATE QR',
        onTap: () {
          _generateBarCode(_inputController.text);
        });
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: context.paddingMedium,
      child: Column(
        children: [
          StandartCard(
            byte: bytes,
          ),
          SizedBox(
            height: 16,
          ),
          _buildTextField(),
          SizedBox(
            height: 16,
          ),
          _buildGenerateButton(),
        ],
      ),
    );
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the button
    Widget okButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('OK'),
    );

    // set up the AlertDialog
    var alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _generateBarCode(String inputCode) async {
    var result = await scanner.generateBarCode(inputCode);
    setState(() {
      bytes = result;
      addDatabese();
    });
  }

  void addDatabese() async {
    await _databaseHelper
        .insert(GenerateHistoryModel('Url', _inputController.text, bytes));
    setState(() {
      getHistory();
    });
  }

  void getHistory() async {
    var historyFuture = _databaseHelper.getGenereteHistory();

    await historyFuture.then((data) {
      setState(() {
        allHistory = data;
      });
    });
  }
}
