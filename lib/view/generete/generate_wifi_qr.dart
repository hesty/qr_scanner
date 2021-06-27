import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../../core/extension/context_extension.dart';
import '../../core/utils/db_helper.dart';
import '../../core/widget/button/standart_button.dart';
import '../../core/widget/card/standart_card.dart';
import '../../models/generate_history_model.dart';

class GenerateWifiQr extends StatefulWidget {
  GenerateWifiQr({Key? key}) : super(key: key);

  @override
  _GenerateWifiQrState createState() => _GenerateWifiQrState();
}

class _GenerateWifiQrState extends State<GenerateWifiQr> {
  final TextEditingController _nameTextEdittingController =
      TextEditingController();
  final TextEditingController _passwordTextEdittingController =
      TextEditingController();
  final _databaseHelper = DatabaseHelper();
  bool isPasswordVisible = false;
  Uint8List bytes = Uint8List(0);

  List allHistory = <GenerateHistoryModel>[];

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1D1F22),
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        padding: context.paddingMedium,
        child: Column(
          children: [
            StandartCard(byte: bytes),
            SizedBox(
              height: 16,
            ),
            _buildTextFormFields(),
            SizedBox(
              height: 16,
            ),
            buildStandartButton(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Wi-Fi'),
    );
  }

  Widget buildStandartButton() {
    return StandartButton(
        title: 'GENERATE QR',
        onTap: () {
          _generateBarCode('WIFI:' +
              _nameTextEdittingController.text +
              ':' +
              _passwordTextEdittingController.text);
        });
  }

  Future _generateBarCode(String inputCode) async {
    final result = await scanner.generateBarCode(inputCode);
    setState(() => bytes = result);
    await addDatabese();
  }

  Future<void> addDatabese() async {
    await _databaseHelper.insert(GenerateHistoryModel(
        'Wi-Fi',
        'WIFI:' +
            _nameTextEdittingController.text +
            ':' +
            _passwordTextEdittingController.text,
        bytes));
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

  Widget _buildTextFormFields() {
    return Column(
      children: [
        TextField(
          style: TextStyle(color: Colors.white),
          controller: _nameTextEdittingController,
          decoration: InputDecoration(
            hintText: 'Wi-Fi Name',
            labelText: 'Name',
            labelStyle: TextStyle(color: Colors.grey),
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        TextFormField(
          textInputAction: TextInputAction.go,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          obscureText: isPasswordVisible,
          controller: _passwordTextEdittingController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: isPasswordVisible
                  ? Icon(
                      Icons.visibility_off,
                      color: Colors.white,
                    )
                  : Icon(Icons.visibility, color: Colors.white),
              onPressed: () =>
                  setState(() => isPasswordVisible = !isPasswordVisible),
            ),
            hintText: 'Wi-Fi Password',
            labelText: 'Password',
          ),
        ),
      ],
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
}
