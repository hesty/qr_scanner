import 'package:flutter/material.dart';
import 'package:qr_scanner/screens/generete/qr_qenerate_screen.dart';
import 'package:qr_scanner/screens/scan_photo/scan_photo_screen.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_scanner/screens/scan_qr/qr_scan_screen.dart';
import 'package:qr_scanner/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR & Barcode Scanner',
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: SplashScren(),
    );
  }
}

class HomaScreen extends StatefulWidget {
  @override
  _HomaScreenState createState() => _HomaScreenState();
}

class _HomaScreenState extends State<HomaScreen> {
  int _currentIndex = 1;

  final List<Widget> children = [
    QrGenerateScreen(),
    QrScanScreen(),
    ScanPhotoScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    double dynmcH = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: Color(0xff1D1F22),
      body: children[_currentIndex],
      bottomNavigationBar: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: dynmcH),
          child: _buildCustomNavigationBar(),
        ),
      ),
    );
  }

  Widget _buildCustomNavigationBar() {
    void onTappedBar(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    return CustomNavigationBar(
      iconSize: 30.0,
      selectedColor: Color(0xffFFFFFF),
      strokeColor: Color(0xffFFFFFF),
      unSelectedColor: Color(0xffBBC9FE),
      backgroundColor: Color(0xff325CFD),
      borderRadius: Radius.circular(50.0),
      items: [
        CustomNavigationBarItem(
          icon: Icon(Icons.add),
          //title: Text("Generate QR")
        ),
        CustomNavigationBarItem(
          icon: Icon(
            Icons.qr_code,
          ),
          //title: Text("Scan QR")
        ),
        CustomNavigationBarItem(
          icon: Icon(
            Icons.photo,
          ),
          //title: Text("Scan Photo")
        ),
      ],
      onTap: onTappedBar,
      currentIndex: _currentIndex,
      isFloating: true,
    );
  }
}
