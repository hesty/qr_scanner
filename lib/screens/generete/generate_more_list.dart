import 'package:flutter/material.dart';
import 'package:qr_scanner/screens/generete/generate_wifi_qr.dart';
import 'package:qr_scanner/screens/generete/generete_map.dart';
import 'package:qr_scanner/screens/generete/qenerate_mail.dart';

class GenerateMoreList extends StatefulWidget {
  GenerateMoreList({Key key}) : super(key: key);

  @override
  _GenerateMoreListState createState() => _GenerateMoreListState();
}

class _GenerateMoreListState extends State<GenerateMoreList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1D1F22),
      body: Padding(
        padding: EdgeInsets.all(3.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                color: Colors.white,
              ),
              ListTile(
                leading: Icon(
                  Icons.wifi,
                  color: Colors.white,
                ),
                tileColor: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GenerateWifiQr()));
                },
                title: Text(
                  "Wi-Fi",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Divider(
                color: Colors.white,
              ),
              ListTile(
                leading: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                tileColor: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GenerateEmailQr()));
                },
                title: Text("E-Mail", style: TextStyle(color: Colors.white)),
              ),
              Divider(
                color: Colors.white,
              ),
              ListTile(
                leading: Icon(
                  Icons.place,
                  color: Colors.white,
                ),
                tileColor: Colors.blueAccent,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GenerateMap()));
                },
                title: Text("Map Coordinate",
                    style: TextStyle(color: Colors.white)),
              ),
              Divider(
                color: Colors.white,
              ),
              ListTile(
                leading: Icon(
                  Icons.sms,
                  color: Colors.white,
                ),
                tileColor: Colors.blueAccent,
                onTap: () {},
                title: Text("Sms", style: TextStyle(color: Colors.white)),
              ),
              Divider(
                color: Colors.white,
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                tileColor: Colors.blueAccent,
                onTap: () {},
                title:
                    Text("My QR Code", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
