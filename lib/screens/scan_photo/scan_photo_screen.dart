import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_scanner/screens/scan_photo/scan_photo_deatil.dart';
import 'package:qr_scanner/services/adver_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'edit_photo.dart';

// ignore: must_be_immutable
class ScanPhotoScreen extends StatefulWidget {
  File file;
  String sc;
  ScanPhotoScreen({this.file, this.sc});

  @override
  _ScanPhotoScreenState createState() => _ScanPhotoScreenState();
}

class _ScanPhotoScreenState extends State<ScanPhotoScreen> {
  TextEditingController _outputController;

  @override
  void initState() {
    super.initState();
    _scanPath();
    _outputController = new TextEditingController();
    adsk();
    _advertService.disposeAllAdverBottom();
    _advertService.disposeAllAdverTop();
    //_advertService.showBannerTop();
  }

  final AdvertService _advertService = new AdvertService();
  Future adsk() async {
    await Firebase.initializeApp();
    FirebaseAdMob.instance.initialize(
        appId: 'ca-app-pub-4694190778906605~5980739782',
        analyticsEnabled: true);
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Scan Photo",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
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
                        Image.asset(
                          "assets/14.png",
                        ),
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
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.white)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
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
                                  if (_outputController.text != null &&
                                      _outputController.text != "") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ScanPhotoDetail(
                                                  result:
                                                      _outputController.text,
                                                )));
                                  } else {
                                    showAlertDialog(context);
                                  }
                                },
                              ),
                              hintMaxLines: 3,
                              hintText: 'Your Code will be Here.',
                              hintStyle:
                                  TextStyle(fontSize: 12, color: Colors.grey),
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
                            onTap: () async {
                              await adsk();
                              getImage();
                            },
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
          onPressed: () {
            _scanBytes();
          },
          tooltip: 'Take a Photo',
          child: const Icon(Icons.camera_alt_outlined),
        ));
  }

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      Future.delayed(Duration(seconds: 0)).then(
        (value) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditPhotoScreen(arguments: [_image]),
          ),
        ),
      );
    }
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
      title: Text("Scan"),
      content: Text("Scan Photo And Be HAPPY"),
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

  Future _scanPath() async {
    int a = widget.file.toString().indexOf("'");
    int c = widget.file.toString().lastIndexOf(".") + 4;
    String path = widget.file.toString().substring(a + 1, c);

    await Permission.storage.request();
    String barcode = await scanner.scanPath(path);
    setState(() {
      if (barcode != null) {
        this._outputController.text = barcode;

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ScanPhotoDetail(
                      result: _outputController.text,
                    )));
      }
    });
  }
}
