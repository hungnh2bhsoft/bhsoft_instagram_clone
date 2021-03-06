import 'dart:developer';

import 'package:bhsoft_instagram_clone/firebase_options.dart';
import 'package:bhsoft_instagram_clone/providers/providers.dart';
import 'package:bhsoft_instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:bhsoft_instagram_clone/responsive/responsive_layout.dart';
import 'package:bhsoft_instagram_clone/responsive/web_screen_layout.dart';
import 'package:bhsoft_instagram_clone/ui/screens/screens.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
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
  runApp(const InstagramApp());
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
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: kMobileBackgroundColor,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return ChangeNotifierProvider(
                  create: (_) => FeedProvider(),
                  child: ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: const WebScreenLayout(),
                  ),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
