import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:qr_scanner/core/extension/context_extension.dart';

class CustomDialog extends StatefulWidget {
  final String title;
  final TextStyle? titleStyle;
  final String subTitle;
  final Widget? icon;
  final Widget actionWidget;
  final Color? backgroundColor;

  const CustomDialog(
      {Key? key,
      required this.title,
      required this.subTitle,
      required this.actionWidget,
      this.titleStyle,
      this.icon,
      this.backgroundColor})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => CustomDialogState();
}

class CustomDialogState extends State<CustomDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.decelerate);

    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Padding(
          padding: EdgeInsets.all(context.width * .1),
          child: Container(
              height: context.height * .3,
              decoration: BoxDecoration(
                  color: widget.backgroundColor ?? Colors.white,
                  borderRadius: BorderRadius.circular(5.0)),
              child: buildBody(context)),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  widget.title,
                  style: widget.titleStyle ??
                      TextStyle(
                          fontSize: 25,
                          color: Color(0xff325CFD),
                          fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.icon ?? AutoSizeText(''),
                    AutoSizeText(
                      widget.subTitle,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.actionWidget,
        ))
      ],
    );
  }
}
