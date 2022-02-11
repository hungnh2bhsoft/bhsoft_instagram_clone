import 'package:bhsoft_instagram_clone/utils/global_variables.dart';
import 'package:bhsoft_instagram_clone/resources/auth_methods.dart';
import 'package:bhsoft_instagram_clone/utils/global_variables.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    Key? key,
    required this.mobileScreenLayout,
    required this.webScreenLayout,
  }) : super(key: key);

  final Widget mobileScreenLayout;
  final Widget webScreenLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth > kMobileMaxWidth) {
          return webScreenLayout;
        } else {
          return mobileScreenLayout;
        }
      },
    );
  }
}
