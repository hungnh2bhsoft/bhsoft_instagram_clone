import 'dart:developer';

import 'package:bhsoft_instagram_clone/firebase_options.dart';
import 'package:bhsoft_instagram_clone/providers/user_provider.dart';
import 'package:bhsoft_instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:bhsoft_instagram_clone/responsive/responsive_layout.dart';
import 'package:bhsoft_instagram_clone/responsive/web_screen_layout.dart';
import 'package:bhsoft_instagram_clone/ui/screens/screens.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:bhsoft_instagram_clone/utils/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance
      .userChanges()
      .listen((user) => log(user.toString(), name: "FirebaseAuth"));
  runApp(InstagramApp());
}

class InstagramApp extends StatefulWidget {
  const InstagramApp({Key? key}) : super(key: key);

  @override
  State<InstagramApp> createState() => _InstagramAppState();
}

class _InstagramAppState extends State<InstagramApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: "Instagram Clone",
        theme: ThemeData.dark().copyWith(),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            log(snapshot.data.toString(), name: "snapshot");
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}
