import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_scanner/core/widget/button/standart_button.dart';
import 'package:qr_scanner/core/widget/card/standart_card.dart';
import 'package:qr_scanner/model/generate_history_model.dart';
import 'package:qr_scanner/view/_product/widget/normal_sized_box.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import '../../core/init/service/local_database/db_helper.dart';
import '../../core/extension/context_extension.dart';

class GenerateSmsQr extends StatefulWidget {
  GenerateSmsQr({Key? key}) : super(key: key);

  @override
  _GenerateSmsQrState createState() => _GenerateSmsQrState();
}

class _GenerateSmsQrState extends State<GenerateSmsQr> {
  final TextEditingController _numberTextEditingController =
      TextEditingController();

  final TextEditingController _bodyTextEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Uint8List bytes = Uint8List(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sms'),
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: context.paddingMedium,
      child: Column(
        children: [
          StandartCard(byte: bytes),
          NormalSizedBox(),
          _buildTextFields(),
          NormalSizedBox(),
          _buildStandartButton()
        ],
      ),
    );
  }

  Widget _buildStandartButton() {
    return StandartButton(
        title: 'GENERATE QR',
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            await _generateBarCode(
              'sms:' +
                  _numberTextEditingController.text +
                  'body' +
                  _bodyTextEditingController.text,
            );

            await addDatabese();
          }
        });
  }

  Widget _buildTextFields() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Colors.white),
            validator: (String? value) =>
                value!.isEmpty ? 'Please enter the number' : null,
            controller: _numberTextEditingController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                tooltip: 'Paste From Contact',
                icon: Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
                onPressed: () async {
                  //TODO: Connet your contact
                },
              ),
              labelText: 'Number',
            ),
          ),
          NormalSizedBox(),
          TextFormField(
            keyboardType: TextInputType.text,
            validator: (String? value) =>
                value!.isEmpty ? 'Please enter the body' : null,
            maxLines: 5,
            style: TextStyle(color: Colors.white),
            controller: _bodyTextEditingController,
            decoration: InputDecoration(
              labelText: 'Body',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateBarCode(String inputCode) async {
    var result = await scanner.generateBarCode(inputCode);
    setState(() {
      bytes = result;
    });
  }

  Future<void> addDatabese() async {
    await _databaseHelper.insert(GenerateHistoryModel(
        'Sms',
        'sms:' +
            _numberTextEditingController.text +
            'body' +
            _bodyTextEditingController.text,
        bytes));
  }
}
