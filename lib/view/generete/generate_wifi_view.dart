import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../../core/extension/context_extension.dart';
import '../../core/init/service/local_database/db_helper.dart';
import '../../core/widget/button/standart_button.dart';
import '../../core/widget/card/standart_card.dart';
import '../../model/generate_history_model.dart';
import '../_product/widget/normal_sized_box.dart';

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
            NormalSizedBox(),
            _buildTextFormFields(),
            NormalSizedBox(),
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
  }

  Widget _buildTextFormFields() {
    return Column(
      children: [
        TextFormField(
          style: TextStyle(color: Colors.white),
          controller: _nameTextEdittingController,
          decoration: InputDecoration(
            hintText: 'Wi-Fi Name',
            labelText: 'Name',
          ),
        ),
        NormalSizedBox(),
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
}
