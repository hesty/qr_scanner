import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_scanner/core/widget/button/standart_button.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:qr_scanner/core/extension/context_extension.dart';

import 'edit_photo.dart';
import 'scan_photo_deatil.dart';

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
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    //_scanPath();
  }

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
            ),
            _buildOutputTextFormField(context),
            _buildStandartButton()
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0.0,
      title: Text(
        'Scan Photo',
        style: TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildStandartButton() {
    return StandartButton(
        title: 'SCAN PHOTO',
        onTap: () async {
          await getImage();
        });
  }

  Widget _buildOutputTextFormField(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
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
            if (_outputController.text.isNotEmpty &&
                _outputController.text.isNotEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScanPhotoDetail(
                            result: _outputController.text,
                          )));
            }
          },
        ),
        hintMaxLines: 3,
        hintText: 'Your Text will be Here.',
        hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await Future.delayed(Duration(seconds: 0)).then(
        (value) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditPhotoScreen(arguments: [_image]),
          ),
        ),
      );
    }
  }

  Future _scanBytes() async {
    var file = await ImagePicker().getImage(source: ImageSource.gallery);
    if (file == null) return;
    var bytes = file.readAsBytes();
    var barcode = await scanner.scanBytes(await bytes);
    _outputController.text = barcode;
  }

  Future _scanPath() async {
    var a = widget.file.toString().indexOf("'");
    var c = widget.file.toString().lastIndexOf('.') + 4;
    var path = widget.file.toString().substring(a + 1, c);

    await Permission.storage.request();
    var barcode = await scanner.scanPath(path);
    setState(() {
      _outputController.text = barcode;

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ScanPhotoDetail(
                    result: _outputController.text,
                  )));
    });
  }
}
