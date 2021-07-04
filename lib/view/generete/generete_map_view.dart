import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_scanner/core/widget/button/standart_button.dart';
import 'package:qr_scanner/core/widget/card/standart_card.dart';
import 'package:qr_scanner/model/generate_history_model.dart';
import 'package:qr_scanner/view/_product/widget/normal_sized_box.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import '../../core/extension/context_extension.dart';

import '../../core/init/service/local_database/db_helper.dart';

class GenerateMap extends StatefulWidget {
  GenerateMap({Key? key}) : super(key: key);

  @override
  _GenerateMapState createState() => _GenerateMapState();
}

class _GenerateMapState extends State<GenerateMap> {
  final TextEditingController? _latitudeTextEditingController =
      TextEditingController();

  final TextEditingController? _longitudeTextEditingController =
      TextEditingController();

  final TextEditingController? _queryTextEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  bool isPasswordVisible = false;

  Uint8List bytes = Uint8List(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: context.paddingMedium,
        child: _buildBodyColumn(),
      ),
    );
  }

  Widget _buildBodyColumn() {
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
            _generateBarCode('o:' +
                _latitudeTextEditingController!.text +
                '.0,' +
                _longitudeTextEditingController!.text +
                '.0?q=' +
                _queryTextEditingController!.text);
          }
        });
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Map Coordinate'),
    );
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
                value!.isEmpty ? 'Please enter the latitude' : null,
            controller: _latitudeTextEditingController,
            decoration: InputDecoration(
              labelText: 'Latitude',
            ),
          ),
          NormalSizedBox(),
          TextFormField(
              keyboardType: TextInputType.phone,
              validator: (String? value) =>
                  value!.isEmpty ? 'Please enter the longitude' : null,
              style: TextStyle(color: Colors.white),
              obscureText: isPasswordVisible,
              controller: _longitudeTextEditingController,
              decoration: InputDecoration(
                labelText: 'Longitude',
              )),
          NormalSizedBox(),
          TextFormField(
            keyboardType: TextInputType.url,
            validator: (String? value) =>
                value!.isEmpty ? 'Please enter the query parameter' : null,
            style: TextStyle(color: Colors.white),
            obscureText: isPasswordVisible,
            controller: _queryTextEditingController,
            decoration: InputDecoration(
              labelText: 'Query',
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
    await addDatabese();
  }

  Future<void> addDatabese() async {
    await _databaseHelper.insert(GenerateHistoryModel(
        'Map',
        'o:' +
            _latitudeTextEditingController!.text +
            '.0,' +
            _longitudeTextEditingController!.text +
            '.0?q=' +
            _queryTextEditingController!.text,
        bytes));
  }
}
