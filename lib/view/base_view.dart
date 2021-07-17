import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'generate_qr/qr_qenerate_base_view.dart';
import 'scan_photo/scan_photo_screen.dart';
import 'scan_qr/qr_scan_screen.dart';
import 'package:qr_scanner/core/extension/context_extension.dart';

class BaseView extends StatefulWidget {
  BaseView({Key? key}) : super(key: key);

  @override
  _BaseViewState createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  int _currentIndex = 1;

  final List<Widget> children = [
    QrGenerateScreen(),
    QrScanScreen(),
    ScanPhotoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: changeView(),
      bottomNavigationBar: _buildCustomNavigationBar(),
    );
  }

  Widget _buildCustomNavigationBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.height * .02),
      child: CustomNavigationBar(
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
      ),
    );
  }

  Widget changeView() {
    switch (_currentIndex) {
      case 0:
        return QrGenerateScreen();
      case 1:
        return QrScanScreen();
      case 2:
        return ScanPhotoScreen();
      default:
        return QrScanScreen();
    }
  }

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
