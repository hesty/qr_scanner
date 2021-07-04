import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'generete/qr_qenerate_base_view.dart';
import 'scan_photo/scan_photo_screen.dart';
import 'scan_qr/qr_scan_screen.dart';

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
