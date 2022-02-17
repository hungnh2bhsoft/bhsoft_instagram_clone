import 'package:bhsoft_instagram_clone/models/models.dart';
import 'package:bhsoft_instagram_clone/providers/user_provider.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:bhsoft_instagram_clone/utils/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _currentIndex = 4;

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: user == null
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : PageView.builder(
              controller: _pageController,
              itemBuilder: (_, index) {
                return homePageItems[index];
              },
              itemCount: homePageItems.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: kMobileBackgroundColor,
        currentIndex: _currentIndex,
        onTap: selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
            backgroundColor: kprimaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "",
            backgroundColor: kprimaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "",
            backgroundColor: kprimaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "",
            backgroundColor: kprimaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "",
            backgroundColor: kprimaryColor,
          ),
        ],
      ),
    );
  }

  void selectPage(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

    setState(() {
      _currentIndex = index;
    });
  }
}
