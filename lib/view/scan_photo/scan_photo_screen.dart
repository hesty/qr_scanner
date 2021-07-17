import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_scanner/view/_product/widget/normal_sized_box.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../../core/extension/context_extension.dart';
import '../../core/widget/button/standart_button.dart';
import 'scan_photo_detail.dart';

// ignore: must_be_immutable
class ScanPhotoScreen extends StatefulWidget {
  File? file;
  String? sc;
  ScanPhotoScreen({this.file, this.sc});

  @override
  _ScanPhotoScreenState createState() => _ScanPhotoScreenState();
}

class _ScanPhotoScreenState extends State<ScanPhotoScreen> {
  final TextEditingController _outputController = TextEditingController();
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: context.paddingMedium,
        child: Column(
          children: [
            Image.asset(
              'assets/14.png',
              height: context.height * 0.4,
            ),
            NormalSizedBox(),
            _buildOutputTextFormField(context),
            NormalSizedBox(),
            _buildStandartButton()
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Scan Photo',
      ),
    );
  }

  Widget _buildStandartButton() {
    return StandartButton(
        title: 'SCAN PHOTO',
        onTap: () async {
          await _scanBytes();
        });
  }

  Widget _buildOutputTextFormField(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      readOnly: true,
      controller: _outputController,
      maxLines: 1,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.qr_code,
          color: Colors.white,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {
            if (_outputController.text.isNotEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScanPhotoDetailView(
                            result: _outputController.text,
                          )));
            }
          },
        ),
        hintMaxLines: 3,
        hintText: 'Result will be here.',
        hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  Future _scanBytes() async {
    try {
      var file = await ImagePicker().getImage(source: ImageSource.gallery);
      if (file == null) return;
      var bytes = file.readAsBytes();
      var barcode = await scanner.scanBytes(await bytes);
      _outputController.text = barcode;
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScanPhotoDetailView(
                    result: barcode,
                  )));
    } catch (e) {
      throw Exception(e);
    }
  }
}
