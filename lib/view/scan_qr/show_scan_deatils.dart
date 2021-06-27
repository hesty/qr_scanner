import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/db_scan_history.dart';
import '../../models/scan_history_model.dart';
import 'scan_qr_history.dart';

class ShowDeatilsScan extends StatefulWidget {
  final result;
  ShowDeatilsScan(this.result);

  @override
  _ShowDeatilsScanState createState() => _ShowDeatilsScanState();
}

class _ShowDeatilsScanState extends State<ShowDeatilsScan> {
  TextEditingController? _outputController;

  String link = '';
  final urlRegExp = RegExp(
      r'((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?');
  final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final telNumberRegExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');

  Uint8List? bytes;

  final DbScanHistory _databaseHelper = DbScanHistory();

  List allHistory = <ScanHistoryModel>[];

  void AddDatabese() async {
    await _databaseHelper.insertForScan(ScanHistoryModel(widget.result, bytes));
    setState(() {
      getHistory();
    });
  }

  void getHistory() async {
    var historyFuture = _databaseHelper.getScanHistory();

    await historyFuture.then((data) {
      setState(() {
        allHistory = data;
      });
    });
  }

  Future _generateBarCode() async {
    var result = await scanner.generateBarCode(widget.result);
    setState(() {
      bytes = result;
      AddDatabese();
    });
  }

  @override
  void initState() {
    super.initState();
    _generateBarCode();
    _outputController = TextEditingController();
    setState(() {
      _outputController!.text = widget.result;

      if (_outputController!.text.startsWith(urlRegExp)) {
        link = 'Url';
      } else if (_outputController!.text.startsWith(emailRegExp)) {
        link = 'E-Mail';
      } else if (_outputController!.text.startsWith(telNumberRegExp)) {
        link = 'Telephone Number';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1D1F22),
      appBar: AppBar(
        actions: [
          IconButton(
            alignment: Alignment.center,
            padding: EdgeInsets.only(),
            tooltip: 'History',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScanQrHistory(
                            history: allHistory,
                          )));
            },
            icon: Icon(
              Icons.restore,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
        centerTitle: true,
        title: Text('Show Details'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: _outputController,
              maxLines: 1,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                labelText: link,
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                hintText: 'You scan will be displayed in this area.',
                hintStyle: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xff325CFD),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: InkWell(
                  onTap: () {
                    if (_outputController!.text != null &&
                        _outputController!.text != '') {
                      Clipboard.setData(
                          ClipboardData(text: _outputController!.text));
                      showAlertDialog(context);
                    }
                  },
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.copy,
                        color: Colors.white,
                      ),
                      Text(
                        'Copy',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xff325CFD),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: InkWell(
                  onTap: () {
                    final RenderBox? box =
                        context.findRenderObject() as RenderBox?;
                    if (_outputController!.text != null &&
                        _outputController!.text != '') {
                      Share.share(_outputController!.text,
                          sharePositionOrigin:
                              box!.localToGlobal(Offset.zero) & box.size);
                    }
                  },
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      Text(
                        'Share',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xff325CFD),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: InkWell(
                  onTap: () {
                    launch(_outputController!.text);
                  },
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.launch,
                        color: Colors.white,
                      ),
                      Text(
                        'Open with\nBrowser ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  )),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xff325CFD),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: InkWell(
                  onTap: () {
                    launch('https://www.google.com/search?q=' +
                        _outputController!.text);
                  },
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  )),
                ),
              ),
            ],
          ),
          Spacer(
            flex: 1,
          ),
        ],
      ),
    );
  }

  // ignore: always_declare_return_types
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    var alert = AlertDialog(
      title: Text('Great'),
      content: Text('Copied to Clipboard'),
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
