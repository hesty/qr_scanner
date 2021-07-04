import 'package:flutter/material.dart';

class StandartButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  StandartButton({required this.title, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
      onTap: onTap,
      child: Ink(
        width: 200,
        height: 60,
        decoration: BoxDecoration(
            color: Color(0xff325CFD),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15))),
        child: Center(
            child: Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
