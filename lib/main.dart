import 'package:flutter/material.dart';

import 'core/init/theme/dark_app_theme.dart';
import 'view/splash_view.dart';

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
      home: SplashView(),
    );
  }
}
