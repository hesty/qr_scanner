import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../../core/extension/context_extension.dart';
import '../../core/init/service/local_database/db_helper.dart';
import '../../core/widget/button/standart_button.dart';
import '../../core/widget/card/standart_card.dart';
import '../../model/generate_history_model.dart';
import '../_product/widget/normal_sized_box.dart';

class GeneratePhoneView extends StatefulWidget {
  GeneratePhoneView({key}) : super(key: key);

  @override
  _GeneratePhoneViewState createState() => _GeneratePhoneViewState();
}

class _GeneratePhoneViewState extends State<GeneratePhoneView> {
  final TextEditingController _phoneTextEditingController =
      TextEditingController();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List allHistory = <GenerateHistoryModel>[];
  Uint8List bytes = Uint8List(0);
  TabController? tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1D1F22),
      body: SingleChildScrollView(
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
      ),
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: _phoneTextEditingController,
      maxLines: 1,
      keyboardType: TextInputType.phone,
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
          _generateBarCode(_phoneTextEditingController.text);
        });
  }

  Future<void> _generateBarCode(String inputCode) async {
    var result = await scanner.generateBarCode(inputCode);
    setState(() => bytes = result);
    addDatabese();
  }

  void addDatabese() async {
    await _databaseHelper.insert(
        GenerateHistoryModel('Phone', _phoneTextEditingController.text, bytes));
  }
}
