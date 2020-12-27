import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:share/share.dart';

class ScanPhotoScreen extends StatefulWidget {
  ScanPhotoScreen({Key key}) : super(key: key);

  @override
  _ScanPhotoScreenState createState() => _ScanPhotoScreenState();
}

class _ScanPhotoScreenState extends State<ScanPhotoScreen> {
  TextEditingController _outputController;

  @override
  void initState() {
    super.initState();
    _outputController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 1),
                child: Center(
                  child: SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15))),
                      child: Text(
                        "Scan Photo",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              flex: 1,
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(color: Color(0xff1D1F22)),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset("assets/14.png"),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            controller: _outputController,
                            maxLines: 1,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.go,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: Column(
                                children: [
                                  Material(
                                    color: Colors.white.withOpacity(0.0),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.copy,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        if (_outputController.text != null &&
                                            _outputController.text != "") {
                                          Clipboard.setData(new ClipboardData(
                                              text: _outputController.text));
                                          showAlertDialog(context);
                                        }
                                      },
                                    ),
                                  ),
                                  Material(
                                    color: Colors.white.withOpacity(0.0),
                                    child: IconButton(
                                        splashColor: Colors.white,
                                        icon: Icon(
                                          Icons.share,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          final RenderBox box =
                                              context.findRenderObject();
                                          if (_outputController.text != null &&
                                              _outputController.text != "") {
                                            Share.share(_outputController.text,
                                                sharePositionOrigin:
                                                    box.localToGlobal(
                                                            Offset.zero) &
                                                        box.size);
                                          }
                                        }),
                                  ),
                                ],
                              ),
                              prefixIcon: Icon(
                                Icons.qr_code,
                                color: Colors.white,
                              ),
                              hintMaxLines: 3,
                              hintText:
                                  'The barcode or qrcode you scan will be displayed in this area.',
                              hintStyle:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //**build Scan button
                        Material(
                          color: Colors.white.withOpacity(0.0),
                          child: InkWell(
                            onTap: _scanPhoto,
                            child: Container(
                              width: 200,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Color(0xff325CFD),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15))),
                              child: Center(
                                  child: Text(
                                "SCAN PHOTO",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xff1D1F22),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff325CFD),
          onPressed: () => _scanBytes(),
          tooltip: 'Take a Photo',
          child: const Icon(Icons.camera_alt_outlined),
        ));
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Great"),
      content: Text("Copied to Clipboard"),
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

  Future _scanBytes() async {
    File file = await ImagePicker.pickImage(source: ImageSource.camera);
    if (file == null) return;
    Uint8List bytes = file.readAsBytesSync();
    String barcode = await scanner.scanBytes(bytes);
    this._outputController.text = barcode;
  }

  Future _scanPhoto() async {
    await Permission.storage.request();
    String barcode = await scanner.scanPhoto();
    setState(() {
      this._outputController.text = barcode;
    });
  }
}
