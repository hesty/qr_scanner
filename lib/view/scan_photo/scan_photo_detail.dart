import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_scanner/core/constants/regexp_constants.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_scanner/core/extension/context_extension.dart';

class ScanPhotoDetailView extends StatefulWidget {
  final String result;

  ScanPhotoDetailView({required this.result});

  @override
  _ScanPhotoDetailViewState createState() => _ScanPhotoDetailViewState();
}

class _ScanPhotoDetailViewState extends State<ScanPhotoDetailView> {
  final TextEditingController _outputController = TextEditingController();

  String link = '';

  @override
  void initState() {
    super.initState();

    setState(() {
      _outputController.text = widget.result;

      if (_outputController.text
          .startsWith(RegexpConstans.instance.urlRegExp)) {
        link = 'Url';
      } else if (_outputController.text
          .startsWith(RegexpConstans.instance.emailRegExp)) {
        link = 'E-Mail';
      } else if (_outputController.text
          .startsWith(RegexpConstans.instance.telNumberRegExp)) {
        link = 'Telephone Number';
      } else {
        link = 'Text';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Details'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: context.paddingMedium,
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
                      if (_outputController.text.isNotEmpty) {
                        Clipboard.setData(
                            ClipboardData(text: _outputController.text));
                        // showAlertDialog(context);
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
                      final box = context.findRenderObject() as RenderBox?;
                      if (_outputController.text.isNotEmpty) {
                        Share.share(_outputController.text,
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
                      launch(_outputController.text);
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
                          _outputController.text);
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
}
