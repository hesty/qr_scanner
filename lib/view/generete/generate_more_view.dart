import 'package:flutter/material.dart';

import '../../core/extension/context_extension.dart';
import 'generate_sms_view.dart';
import 'generate_wifi_view.dart';
import 'generete_map_view.dart';
import 'qenerate_mail_view.dart';

class GenerateMoreList extends StatefulWidget {
  GenerateMoreList({Key? key}) : super(key: key);

  @override
  _GenerateMoreListState createState() => _GenerateMoreListState();
}

class _GenerateMoreListState extends State<GenerateMoreList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xff1D1F22), body: _buildBody());
  }

  Widget _buildBody() {
    return Padding(
      padding: context.paddingLow,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
              color: Colors.white,
            ),
            Material(
              color: Color(0xff325CFD),
              child: ListTile(
                leading: Icon(
                  Icons.wifi,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GenerateWifiQr()));
                },
                title: Text(
                  'Wi-Fi',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Material(
              color: Color(0xff325CFD),
              child: ListTile(
                leading: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                // tileColor: Color(0xff325CFD),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GenerateEmailQr()));
                },
                title: Text('E-Mail', style: TextStyle(color: Colors.white)),
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Material(
              color: Color(0xff325CFD),
              child: ListTile(
                leading: Icon(
                  Icons.place,
                  color: Colors.white,
                ),
                //tileColor: Color(0xff325CFD),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GenerateMap()));
                },
                title: Text('Map Coordinate',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Material(
              color: Color(0xff325CFD),
              child: ListTile(
                leading: Icon(
                  Icons.sms,
                  color: Colors.white,
                ),
                //tileColor: Color(0xff325CFD),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GenerateSmsQr()));
                },
                title: Text('Sms', style: TextStyle(color: Colors.white)),
              ),
            ),
            Divider(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
