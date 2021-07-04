import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_scanner/model/generate_history_model.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:wc_flutter_share/wc_flutter_share.dart';

import '../../core/init/service/local_database/db_helper.dart';

class GenerateMap extends StatefulWidget {
  GenerateMap({Key? key}) : super(key: key);

  @override
  _GenerateMapState createState() => _GenerateMapState();
}

class _GenerateMapState extends State<GenerateMap> {
  TextEditingController? _textEditingController;
  TextEditingController? _textEditingController2;
  TextEditingController? _textEditingController3;
  bool isPasswordVisible = false;
  Uint8List bytes = Uint8List(0);

  final _databaseHelper = DatabaseHelper();

  List allHistory =<GenerateHistoryModel> [];
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController2 = TextEditingController();
    _textEditingController3 = TextEditingController();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1D1F22),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Map Coordinate'),
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
                              if (_textEditingController!.text.isNotEmpty &&
                                  _textEditingController!.text.isNotEmpty &&
                                  _textEditingController2!.text.isNotEmpty &&
                                  _textEditingController2!.text.isNotEmpty &&
                                  _textEditingController3!.text.isNotEmpty &&
                                  _textEditingController3!.text.isNotEmpty) {
                                _generateBarCode('o:' +
                                    _textEditingController!.text +
                                    '.0,' +
                                    _textEditingController2!.text +
                                    '.0?q=' +
                                    _textEditingController3!.text);
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
    var result = await scanner.generateBarCode(inputCode);
    setState(() {
      bytes = result;
      AddDatabese();
    });
  }

  void AddDatabese() async {
    await _databaseHelper.insert(GenerateHistoryModel(
        'Map',
        'o:' +
            _textEditingController!.text +
            '.0,' +
            _textEditingController2!.text +
            '.0?q=' +
            _textEditingController3!.text,
        bytes));
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

  Container _buildGenerateButton() {
    return Container(
      width: 200,
      height: 60,
      decoration: BoxDecoration(
          color: Color(0xff325CFD),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), bottomLeft: Radius.circular(15))),
      child: Center(
          child: Text(
        'GENERATE QR',
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      )),
    );
  }

  Padding _buildTextField() {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.go,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Latitude',
              hintStyle: TextStyle(color: Colors.grey),
              labelText: 'Latitude',
              labelStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white)),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.go,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            obscureText: isPasswordVisible,
            controller: _textEditingController2,
            decoration: InputDecoration(
              hintText: 'Longitude',
              hintStyle: TextStyle(color: Colors.grey),
              labelText: 'Longitude',
              labelStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
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
            controller: _textEditingController3,
            decoration: InputDecoration(
              hintText: 'Query',
              hintStyle: TextStyle(color: Colors.grey),
              labelText: 'Query',
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
                              onTap: () =>
                                  setState(() => this.bytes = Uint8List(0)),
                              child: Center(
                                child: Text(
                                  'Remove',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xff325CFD)),
                                  textAlign: TextAlign.left,
                                ),
                              ),
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
                                var result = await (ImageGallerySaver.saveImage(
                                    this.bytes));
                                if (result['isSuccess']) {
                                  showAlertDialog(
                                      context, 'Save', 'Successful');
                                } else {
                                  showAlertDialog(context, 'Save', 'Failed!');
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
                              if (bytes.isNotEmpty) {
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

  // ignore: always_declare_return_types
  showAlertDialog(BuildContext context, String title, String message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of(context).pop();
      },
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
}
