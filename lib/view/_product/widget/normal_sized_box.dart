import 'package:flutter/material.dart';

class NormalSizedBox extends StatefulWidget {
  NormalSizedBox({Key? key}) : super(key: key);

  @override
  _NormalSizedBoxState createState() => _NormalSizedBoxState();
}

class _NormalSizedBoxState extends State<NormalSizedBox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16.0,
    );
  }
}
