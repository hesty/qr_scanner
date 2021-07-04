import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'core/init/theme/dark_app_theme.dart';
import 'view/generete/qr_qenerate_base_view.dart';
import 'view/scan_photo/scan_photo_screen.dart';
import 'view/scan_qr/qr_scan_screen.dart';
import 'view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR & Barcode Scanner',
      theme: DarkTheme.instance.theme,
      home: SplashScren(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  final List<Widget> children = [
    QrGenerateScreen(),
    QrScanScreen(),
    ScanPhotoScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: children[_currentIndex],
      bottomNavigationBar: SingleChildScrollView(
        child: _buildCustomNavigationBar(),
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
        ),
        CustomNavigationBarItem(
          icon: Icon(
            Icons.qr_code,
          ),
        ),
        CustomNavigationBarItem(
          icon: Icon(
            Icons.photo,
          ),
        ),
      ],
      onTap: onTappedBar,
      currentIndex: _currentIndex,
      isFloating: true,
    );
  }
}
