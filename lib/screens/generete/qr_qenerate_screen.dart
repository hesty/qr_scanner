import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_scanner/screens/generete/generate_more_list.dart';
import 'package:qr_scanner/screens/generete/generate_phone.dart';
import 'package:qr_scanner/screens/generete/generete_url.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:wc_flutter_share/wc_flutter_share.dart';

class QrGenerateScreen extends StatefulWidget {
  QrGenerateScreen({key}) : super(key: key);

  @override
  _QrGenerateScreenState createState() => _QrGenerateScreenState();
}

class _QrGenerateScreenState extends State<QrGenerateScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _inputController;

  Uint8List bytes = Uint8List(0);

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, initialIndex: 0, length: 4);

    _inputController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Generate",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        // toolbarHeight: ,
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          labelColor: Colors.white,
          controller: tabController,
          indicatorColor: Color(0xff325CFD),
          tabs: [
            Tab(
              text: "Text",
            ),
            Tab(
              text: "Url",
            ),
            Tab(
              text: 'Phone',
            ),
            Tab(
              icon: Icon(Icons.menu),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xff1D1F22),
      body: TabBarView(
        controller: tabController,
        children: [
          _buildBody(),
          QrGenerateUrl(),
          QrGeneratePhone(),
          GenerateMoreList(),
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

  Future _generateBarCode(String inputCode) async {
    Uint8List result = await scanner.generateBarCode(inputCode);
    this.setState(() => this.bytes = result);
  }

  Expanded _buildGenerateTitle() {
    return Expanded(
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
                "Generate",
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
    );
  }

  Widget _buildTextField() {
    return Stack(alignment: Alignment.centerRight, children: [
      TextField(
        onSubmitted: (value) {
          _generateBarCode(value);
        },
        style: TextStyle(color: Colors.white),
        controller: _inputController,
        maxLines: 1,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.go,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: Icon(
            Icons.text_fields,
            color: Colors.white,
          ),
          hintText: 'Please Input Your Code',
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ),
      Material(
        color: Colors.white.withOpacity(0.0),
        child: IconButton(
          tooltip: 'Paste to ClipBoard',
          icon: Icon(
            Icons.paste,
            color: Colors.white,
          ),
          onPressed: () async {
            ClipboardData data = await Clipboard.getData('text/plain');
            setState(() {
              _inputController.text = data.text.toString();
            });
          },
        ),
      ),
    ]);
  }

  _buildGenerateButton() {
    return Container(
      width: 200,
      height: 60,
      decoration: BoxDecoration(
          color: Color(0xff325CFD),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), bottomLeft: Radius.circular(15))),
      child: Center(
          child: Text(
        "GENERATE QR",
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      )),
    );
  }

  _buildBody() {
    return Column(
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
                          onTap: () =>
                              _generateBarCode(this._inputController.text),
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
        SizedBox(height: 10),
      ],
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
