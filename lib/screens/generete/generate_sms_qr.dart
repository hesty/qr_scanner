import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:wc_flutter_share/wc_flutter_share.dart';

import '../../models/generate_history_model.dart';
import '../../utils/db_helper.dart';

class GenerateSmsQr extends StatefulWidget {
  GenerateSmsQr({Key key}) : super(key: key);

  @override
  _GenerateSmsQrState createState() => _GenerateSmsQrState();
}

class _GenerateSmsQrState extends State<GenerateSmsQr> {
  TextEditingController _textEditingController;
  TextEditingController _textEditingController2;
  Uint8List bytes = Uint8List(0);
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController2 = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff1D1F22),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Sms'),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: _buildBody());
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
        'Sms',
        'sms:' +
            _textEditingController.text +
            '?body=' +
            _textEditingController2.text,
        bytes));
    setState(() {
      getHistory();
    });
  }

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<GenerateHistoryModel> allHistory = <GenerateHistoryModel>[];

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
              suffixIcon: IconButton(
                tooltip: 'Paste From Contact',
                icon: Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
                onPressed: () async {
                  // await FlutterContactPicker.requestPermission();
                  // final contact =
                  //     await FlutterContactPicker.pickPhoneContact();
                  // setState(() {
                  // _textEditingController.text = contact.phoneNumber.number;
                  // });
                },
              ),
              hintText: 'Number',
              hintStyle: TextStyle(color: Colors.grey),
              labelText: 'Number',
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
            keyboardType: TextInputType.text,
            maxLines: 5,
            textInputAction: TextInputAction.go,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            controller: _textEditingController2,
            decoration: InputDecoration(
              hintText: 'Body',
              hintStyle: TextStyle(color: Colors.grey),
              labelText: 'Body',
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
                              onTap: () =>
                                  setState(() => this.bytes = Uint8List(0)),
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
                                  showAlertDialog(context, 'Great', 'Saved');
                                } else {
                                  showAlertDialog(
                                      context, 'Error', 'Save failed!');
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
                              if (bytes != null) {
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

  Widget _buildBody() {
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
                          onTap: () {
                            print(_textEditingController.text);
                            if (_textEditingController.text != null &&
                                _textEditingController.text != '' &&
                                _textEditingController2.text != null &&
                                _textEditingController2.text != '') {
                              _generateBarCode('sms:' +
                                  _textEditingController.text +
                                  '?body=' +
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
    );
  }
}
