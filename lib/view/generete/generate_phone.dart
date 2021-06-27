import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../../core/extension/context_extension.dart';
import '../../core/utils/db_helper.dart';
import '../../core/widget/button/standart_button.dart';
import '../../core/widget/card/standart_card.dart';
import '../../models/generate_history_model.dart';

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
          SizedBox(
            height: 16,
          ),
          _buildTextField(),
          SizedBox(
            height: 16,
          ),
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
      textInputAction: TextInputAction.go,
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
            //await FlutterContactPicker.requestPermission();
            //final contact = await FlutterContactPicker.pickPhoneContact();
            //setState(() {
            //  _inputController.text = contact.phoneNumber.number;
            //});
          },
        ),
        hintText: '+90xxxxxxxxxx',
        hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
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
