import 'dart:developer';

import 'package:bhsoft_instagram_clone/models/models.dart';
import 'package:bhsoft_instagram_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user!;
    return Scaffold(
      body: Center(
        child: Text(user.username),
      ),
    );
  }
}
