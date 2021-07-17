import 'package:flutter/material.dart';

import '../../core/extension/context_extension.dart';
import 'generate_sms_view.dart';
import 'generate_wifi_view.dart';
import 'generate_map_view.dart';
import 'qenerate_mail_view.dart';

class GenerateMoreList extends StatefulWidget {
  GenerateMoreList({Key? key}) : super(key: key);

  @override
  _GenerateMoreListState createState() => _GenerateMoreListState();
}

class _GenerateMoreListState extends State<GenerateMoreList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: context.paddingLow,
      child: Column(
        children: [
          buildNavigateWifiListTile(),
          _normalDiveder(),
          buildNavigateEmailListTile(),
          _normalDiveder(),
          buildNavigateMapListTile(),
          _normalDiveder(),
          buildNavigateSmsListTile(),
        ],
      ),
    );
  }

  Widget buildNavigateEmailListTile() {
    return ListTile(
      tileColor: Color(0xff325CFD),
      leading: Icon(
        Icons.email,
        color: Colors.white,
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => GenerateEmailQr()));
      },
      title: Text('E-Mail', style: TextStyle(color: Colors.white)),
    );
  }

  Widget buildNavigateMapListTile() {
    return ListTile(
      tileColor: Color(0xff325CFD),
      leading: Icon(
        Icons.place,
        color: Colors.white,
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GenerateMap()));
      },
      title: Text('Map Coordinate', style: TextStyle(color: Colors.white)),
    );
  }

  Widget buildNavigateSmsListTile() {
    return ListTile(
      tileColor: Color(0xff325CFD),
      leading: Icon(
        Icons.sms,
        color: Colors.white,
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GenerateSmsQr()));
      },
      title: Text('Sms', style: TextStyle(color: Colors.white)),
    );
  }

  Widget buildNavigateWifiListTile() {
    return ListTile(
      tileColor: Color(0xff325CFD),
      leading: Icon(
        Icons.wifi,
        color: Colors.white,
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GenerateWifiQr()));
      },
      title: Text(
        'Wi-Fi',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _normalDiveder() {
    return Divider(
      color: Colors.white,
    );
  }
}
