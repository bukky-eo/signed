import 'package:flutter/material.dart';
import 'package:signed/helpers/constants.dart';

class Responsive extends StatefulWidget {
  final Widget mobileScreen;
  final Widget desktopScreen;
  const Responsive(
      {Key? key, required this.mobileScreen, required this.desktopScreen})
      : super(key: key);

  @override
  State<Responsive> createState() => _ResponsiveState();
}

class _ResponsiveState extends State<Responsive> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 900) {
        isMobile = true;
        isWeb = false;
        return widget.mobileScreen;
      } else {
        isMobile = false;
        isWeb = true;
        return widget.desktopScreen;
      }
    });
  }
}
