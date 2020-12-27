import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:share/share.dart';

class QrScanScreen extends StatefulWidget {
  QrScanScreen({key}) : super(key: key);

  @override
  _QrScanScreenState createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  TextEditingController _outputController;

  @override
  void initState() {
    super.initState();
    this._outputController = new TextEditingController();
  }

  final key = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff1D1F22),
        body: Column(
          children: [
            _buildTitle(),
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
                          "assets/asa.png",
                          height: MediaQuery.of(context).size.height * 0.30,
                        ),
                        _buildOutTextField(),
                        SizedBox(
                          height: 20,
                        ),
                        //build scan button
                        Material(
                          color: Colors.white.withOpacity(0.0),
                          child: InkWell(
                            splashColor: Colors.white,
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
                                "SCAN QR",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                            onTap: () {
                              _scan();
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
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

  Future _scan() async {
    await Permission.camera.request();
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('Nothing return.');
    } else {
      setState(() {
        this._outputController.text = barcode;
      });
    }
  }

  Widget _buildOutTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: _outputController,
        maxLines: 3,
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
                      Clipboard.setData(
                          new ClipboardData(text: _outputController.text));
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
                      final RenderBox box = context.findRenderObject();
                      if (_outputController.text != null &&
                          _outputController.text != "") {
                        Share.share(_outputController.text,
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size);
                      }
                    }),
              ),
            ],
          ),
          prefixIcon: Icon(
            Icons.qr_code,
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: 'You scan will be displayed in this area.',
          hintStyle: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }
}

Expanded _buildTitle() {
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
              "Scan QR",
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
