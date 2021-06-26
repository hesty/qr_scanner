import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:wc_flutter_share/wc_flutter_share.dart';

import '../../models/generate_history_model.dart';
import '../../utils/db_helper.dart';

class QrGeneratePhone extends StatefulWidget {
  QrGeneratePhone({key}) : super(key: key);

  @override
  _QrGeneratePhoneState createState() => _QrGeneratePhoneState();
}

class _QrGeneratePhoneState extends State<QrGeneratePhone> {
  TextEditingController _inputController;

  Uint8List bytes = Uint8List(0);

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1D1F22),
      body: _buildBody(),
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
                borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.18,
                    child: bytes.isEmpty
                        ? Center(
                            child: Text('Empty Code', style: TextStyle(color: Colors.black38)),
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
                                  style: TextStyle(fontSize: 15, color: Color(0xff325CFD)),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              onTap: () => setState(() => this.bytes = Uint8List(0)),
                            ),
                          ),
                        ),
                        Text('|', style: TextStyle(fontSize: 15, color: Colors.black26)),
                        Expanded(
                          flex: 5,
                          child: Material(
                            color: Colors.white.withOpacity(0.0),
                            child: InkWell(
                              onTap: () async {
                                await Permission.storage.request();
                                Map result = await ImageGallerySaver.saveImage(this.bytes);
                                if (result['isSuccess']) {
                                  showAlertDialog(context, 'Great', 'Saved');
                                } else {
                                  showAlertDialog(context, 'Error', 'Save failed!');
                                }
                              },
                              child: Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(fontSize: 15, color: Color(0xff325CFD)),
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
                                    sharePopupTitle: 'share', fileName: 'share.png', mimeType: 'image/png', bytesOfFile: bytes);
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
    var result = await scanner.generateBarCode(inputCode);
    setState(() => bytes = result);
    AddDatabese();
  }

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  void AddDatabese() async {
    await _databaseHelper.insert(GenerateHistoryModel('Phone', _inputController.text, bytes));
    setState(() {
      getHistory();
    });
  }

  List<GenerateHistoryModel> allHistory = <GenerateHistoryModel>[];

  void getHistory() async {
    var historyFuture = _databaseHelper.getGenereteHistory();

    await historyFuture.then((data) {
      setState(() {
        allHistory = data;
      });
    });
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
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.go,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(5),
          ),
          prefixIcon: Icon(
            Icons.phone,
            color: Colors.white,
          ),
          hintText: '+90xxxxxxxxxx',
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ),
      Material(
          color: Colors.white.withOpacity(0.0),
          child: IconButton(
            tooltip: 'Paste From Contact',
            icon: Icon(
              Icons.person_add,
              color: Colors.white,
            ),
            onPressed: () async {
              await FlutterContactPicker.requestPermission();
              final contact = await FlutterContactPicker.pickPhoneContact();
              setState(() {
                _inputController.text = contact.phoneNumber.number;
              });
            },
          )),
    ]);
  }

  Container _buildGenerateButton() {
    return Container(
      width: 200,
      height: 60,
      decoration:
          BoxDecoration(color: Color(0xff325CFD), borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15))),
      child: Center(
          child: Text(
        'GENERATE QR',
        style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      )),
    );
  }

  Column _buildBody() {
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
                          onTap: () => _generateBarCode(_inputController.text),
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
