import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_scanner/model/generate_history_model.dart';
import 'package:qr_scanner/view/_product/widget/normal_sized_box.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../../core/extension/context_extension.dart';
import '../../core/init/service/local_database/db_helper.dart';
import '../../core/widget/button/standart_button.dart';
import '../../core/widget/card/standart_card.dart';

class QrGeneratePhone extends StatefulWidget {
  QrGeneratePhone({key}) : super(key: key);

  @override
  _QrGeneratePhoneState createState() => _QrGeneratePhoneState();
}

class _QrGeneratePhoneState extends State<QrGeneratePhone> {
  final TextEditingController _inputController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List allHistory = <GenerateHistoryModel>[];
  Uint8List bytes = Uint8List(0);
  TabController? tabController;

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

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: context.paddingMedium,
      child: Column(
        children: [
          StandartCard(byte: bytes),
          NormalSizedBox(),
          _buildTextField(),
          NormalSizedBox(),
          _buildStandartButton(),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: _inputController,
      maxLines: 1,
      keyboardType: TextInputType.phone,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.phone,
          color: Colors.white,
        ),
        suffixIcon: IconButton(
          tooltip: 'Paste From Contact',
          icon: Icon(
            Icons.person_add,
            color: Colors.white,
          ),
          onPressed: () async {
            //TODO: Connect your contact
          },
        ),
        hintText: '+90xxxxxxxxxx',
      ),
    );
  }

  Widget _buildStandartButton() {
    return StandartButton(
        title: 'GENERATE QR',
        onTap: () {
          _generateBarCode(_inputController.text);
        });
  }

  Future<void> _generateBarCode(String inputCode) async {
    var result = await scanner.generateBarCode(inputCode);
    setState(() => bytes = result);
    addDatabese();
  }

  void addDatabese() async {
    await _databaseHelper
        .insert(GenerateHistoryModel('Phone', _inputController.text, bytes));
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
