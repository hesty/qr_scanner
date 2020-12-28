import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class GenerateWifiQr extends StatefulWidget {
  GenerateWifiQr({Key key}) : super(key: key);

  @override
  _GenerateWifiQrState createState() => _GenerateWifiQrState();
}

class _GenerateWifiQrState extends State<GenerateWifiQr> {
  TextEditingController _textEditingController;
  TextEditingController _textEditingController2;
  bool isPasswordVisible = false;
  Uint8List bytes = Uint8List(0);
  @override
  void initState() {
    super.initState();
    _textEditingController = new TextEditingController();
    _textEditingController2 = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1D1F22),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Wi-Fi"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
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
                      _qrCodeWidget(bytes, context),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: _buildTextField(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //**build generate button
                      Material(
                        color: Colors.white.withOpacity(0.0),
                        child: Ink(
                          color: Colors.white.withOpacity(0.0),
                          child: InkWell(
                            onTap: () {
                              print(_textEditingController.text);
                              if (_textEditingController.text != null &&
                                  _textEditingController.text != "" &&
                                  _textEditingController2.text != null &&
                                  _textEditingController2.text != "") {
                                _generateBarCode("WIFI:" +
                                    _textEditingController.text +
                                    ":" +
                                    _textEditingController2.text);
                              }
                            },
                            child: _buildGenerateButton(),
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
    );
  }

  Future _generateBarCode(String inputCode) async {
    Uint8List result = await scanner.generateBarCode(inputCode);
    this.setState(() => this.bytes = result);
  }

  _buildGenerateButton() {
    return Container(
      width: 200,
      height: 60,
      decoration: BoxDecoration(
          color: Color(0xff325CFD),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(5), bottomLeft: Radius.circular(5))),
      child: Center(
          child: Text(
        "GENERATE QR",
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      )),
    );
  }

  _buildTextField() {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.go,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Wi-Fi Name',
              hintStyle: TextStyle(color: Colors.grey),
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.white)),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.go,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            obscureText: isPasswordVisible,
            controller: _textEditingController2,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: isPasswordVisible
                    ? Icon(
                        Icons.visibility_off,
                        color: Colors.white,
                      )
                    : Icon(Icons.visibility, color: Colors.white),
                onPressed: () =>
                    setState(() => isPasswordVisible = !isPasswordVisible),
              ),
              hintText: 'Wi-Fi Password',
              hintStyle: TextStyle(color: Colors.grey),
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qrCodeWidget(Uint8List bytes, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        elevation: 6,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: Color(0xff325CFD),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.18,
                    child: bytes.isEmpty
                        ? Center(
                            child: Text('Empty Code',
                                style: TextStyle(color: Colors.black38)),
                          )
                        : Image.memory(bytes),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 7, left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Material(
                            color: Colors.white.withOpacity(0.0),
                            child: InkWell(
                              child: Center(
                                child: Text(
                                  'Remove',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xff325CFD)),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              onTap: () => this
                                  .setState(() => this.bytes = Uint8List(0)),
                            ),
                          ),
                        ),
                        Text('|',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black26)),
                        Expanded(
                          flex: 5,
                          child: Material(
                            color: Colors.white.withOpacity(0.0),
                            child: InkWell(
                              onTap: () async {
                                await Permission.storage.request();
                                Map result = await ImageGallerySaver.saveImage(
                                    this.bytes);
                                if (result['isSuccess']) {
                                  showAlertDialog(context, "Great", "Saved");
                                } else {
                                  showAlertDialog(
                                      context, "Error", "Save failed!");
                                }
                              },
                              child: Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xff325CFD)),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Color(0xff325CFD),
                            ),
                            onPressed: () async {
                              if (!bytes.isEmpty) {
                                await WcFlutterShare.share(
                                    sharePopupTitle: 'share',
                                    fileName: 'share.png',
                                    mimeType: 'image/png',
                                    bytesOfFile: bytes);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String title, String message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
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
}
