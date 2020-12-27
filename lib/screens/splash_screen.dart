import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import '../main.dart';

class SplashScren extends StatefulWidget {
  SplashScren({Key key}) : super(key: key);

  @override
  _SplashScrenState createState() => _SplashScrenState();
}

class _SplashScrenState extends State<SplashScren> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new HomaScreen(),
        title: new Text(
          'QR & Barcode Reader',
          style: new TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.white),
        ),
        image: Image.asset("assets/16.png"),
        backgroundColor: Color(0xff1D1F22),
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Color(0xff325CFD));
  }
}
