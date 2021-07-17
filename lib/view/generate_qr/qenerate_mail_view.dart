import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../../core/extension/context_extension.dart';
import '../../core/init/service/local_database/db_helper.dart';
import '../../core/widget/button/standart_button.dart';
import '../../core/widget/card/standart_card.dart';
import '../../model/generate_history_model.dart';
import '../_product/widget/normal_sized_box.dart';

class GenerateEmailQr extends StatefulWidget {
  GenerateEmailQr({Key? key}) : super(key: key);

  @override
  _GenerateEmailQrState createState() => _GenerateEmailQrState();
}

class _GenerateEmailQrState extends State<GenerateEmailQr> {
  final TextEditingController _mailTextEditingController =
      TextEditingController();

  final TextEditingController _subjectTextEditingController =
      TextEditingController();

  final TextEditingController _bodyTextEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<GenerateHistoryModel> allHistory = <GenerateHistoryModel>[];

  bool isPasswordVisible = false;

  Uint8List bytes = Uint8List(0);

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Mail'),
      ),
      body: SingleChildScrollView(
        padding: context.paddingMedium,
        child: buildBodyColumn(),
      ),
    );
  }

  Widget buildBodyColumn() {
    return Column(
      children: [
        StandartCard(byte: bytes),
        NormalSizedBox(),
        _buildTextFields(),
        NormalSizedBox(),
        buildStandartButton()
      ],
    );
  }

  Widget buildStandartButton() {
    return StandartButton(
        title: 'GENERATE QR',
        onTap: () {
          if (_formKey.currentState!.validate()) {
            _generateBarCode('mailto:' +
                _mailTextEditingController.text +
                '?subject=' +
                _subjectTextEditingController.text +
                '&body=' +
                _bodyTextEditingController.text);
          }
        });
  }

  Widget _buildTextFields() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildMailTextFormField(),
          NormalSizedBox(),
          buildSubjectTextFormField(),
          NormalSizedBox(),
          buildBodyTextFormField(),
        ],
      ),
    );
  }

  Widget buildBodyTextFormField() {
    return TextFormField(
      cursorColor: Colors.white,
      maxLines: 5,
      validator: (String? value) =>
          value!.isEmpty ? 'Please enter the e-mail body' : null,
      style: TextStyle(color: Colors.white),
      obscureText: isPasswordVisible,
      controller: _bodyTextEditingController,
      decoration: InputDecoration(
        labelText: 'Body',
      ),
    );
  }

  Widget buildSubjectTextFormField() {
    return TextFormField(
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      validator: (String? value) =>
          value!.isEmpty ? 'Please enter the e-mail subject' : null,
      obscureText: isPasswordVisible,
      controller: _subjectTextEditingController,
      decoration: InputDecoration(
        labelText: 'Subject',
      ),
    );
  }

  Widget buildMailTextFormField() {
    return TextFormField(
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      controller: _mailTextEditingController,
      validator: (String? value) =>
          value!.isEmpty ? 'Please enter the e-mail' : null,
      decoration: InputDecoration(
        labelText: 'Mail',
      ),
    );
  }

  Future<void> _generateBarCode(String inputCode) async {
    var result = await scanner.generateBarCode(inputCode);
    setState(() {
      bytes = result;
    });
    addDatabese();
  }

  void addDatabese() async {
    await _databaseHelper.insert(GenerateHistoryModel(
        'E-Mail',
        'mailto:' +
            _mailTextEditingController.text +
            '?subject=' +
            _subjectTextEditingController.text +
            '&body=' +
            _bodyTextEditingController.text,
        bytes));

    await getHistory();
  }

  Future<void> getHistory() async {
    var getHistoryList = await _databaseHelper.getgeneretaHistory();
    setState(() {
      allHistory = getHistoryList;
    });
  }
}
