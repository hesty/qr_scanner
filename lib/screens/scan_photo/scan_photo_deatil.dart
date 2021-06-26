import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanPhotoDetail extends StatefulWidget {
  final result;
  final file;

  ScanPhotoDetail({this.result, this.file});

  @override
  _ScanPhotoDetailState createState() => _ScanPhotoDetailState();
}

class _ScanPhotoDetailState extends State<ScanPhotoDetail> {
  TextEditingController? _outputController;

  String link = '';
  final urlRegExp = RegExp(
      r'((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?');
  final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final telNumberRegExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  Future _scanPath() async {
    var a = widget.file.toString().indexOf("'");
    var c = widget.file.toString().lastIndexOf('.') + 4;
    var path = widget.file.toString().substring(a + 1, c);
    print('Deneme = ' + c.toString());
    await Permission.storage.request();
    var barcode = await scanner.scanPath(path);
    setState(() {
      if (barcode != null) {
        _outputController!.text = barcode;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _outputController = TextEditingController();
    _scanPath();
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
        centerTitle: true,
        title: Text('Show Details'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
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
                      final RenderBox? box = context.findRenderObject() as RenderBox?;
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
          ],
        ),
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
