import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_scanner/screens/scan_qr/show_scan_deatils.dart';
import 'package:qr_scanner/services/adver_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class QrScanScreen extends StatefulWidget {
  QrScanScreen({key}) : super(key: key);

  @override
  _QrScanScreenState createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  TextEditingController _outputController;

  final AdvertService _advertService = new AdvertService();
  Future adsk() async {
    await Firebase.initializeApp();
    FirebaseAdMob.instance.initialize(
        appId: 'ca-app-pub-4694190778906605~5980739782',
        analyticsEnabled: true);
  }

  @override
  void initState() {
    super.initState();
    this._outputController = new TextEditingController();
    adsk();
    _advertService.disposeAllAdverBottom();
    _advertService.disposeAllAdverTop();
    _advertService.showBannerTop();
  }

  final key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Color(0xff1D1F22),
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
                        Text(
                          "Scan QR",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Image.asset(
                          "assets/asa.png",
                          height: MediaQuery.of(context).size.height * 0.4,
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

  Future _scan() async {
    await Permission.camera.request();
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('Nothing return.');
    } else {
      setState(() async {
        this._outputController.text = barcode;
        setState(() {
          _advertService.disposeAllAdverTop();
        });
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ShowDeatilsScan(_outputController.text))).then((value) {
          //_advertService.disposeAllAdverTop();
          _advertService.showBannerTop();
          setState(() {
            _advertService.disposeAllAdverBottom();
          });
        });
      });
    }
  }

  Widget _buildOutTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        onTap: () {},
        style: TextStyle(color: Colors.white),
        controller: _outputController,
        maxLines: 1,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          suffixIcon: Column(
            children: [
              Material(
                color: Colors.white.withOpacity(0.0),
                child: IconButton(
                  tooltip: 'Details',
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () async {
                    if (_outputController.text != null &&
                        _outputController.text != "") {
                      setState(() {
                        _advertService.disposeAllAdverTop();
                      });
                      await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ShowDeatilsScan(_outputController.text)))
                          .then((value) {
                        _advertService.showBannerTop();
                        setState(() {
                          _advertService.disposeAllAdverBottom();
                        });
                      });
                    } else {
                      showAlertDialog(context);
                    }
                  },
                ),
              ),
            ],
          ),
          prefixIcon: Icon(
            Icons.qr_code,
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(5),
          ),
          hintText: 'Your Code will be Here.',
          hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
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
      content: Text("Scan QR And Be HAPPY"),
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
