import 'package:bhsoft_instagram_clone/models/models.dart';
import 'package:bhsoft_instagram_clone/providers/page_manager_provider.dart';
import 'package:bhsoft_instagram_clone/providers/user_provider.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:bhsoft_instagram_clone/utils/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatelessWidget {
  MobileScreenLayout({Key? key}) : super(key: key);

  final PageController _controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).user;
    return ChangeNotifierProvider(
      create: (context) => PageManagerProvider(),
      child: Consumer<PageManagerProvider>(
        builder: (context, manager, _) => Scaffold(
          body: user == null
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : PageView.builder(
                  controller: _controller,
                  itemBuilder: (_, index) {
                    return homePageItems[index];
                  },
                  itemCount: homePageItems.length,
                  onPageChanged: manager.jumpToPage),
          bottomNavigationBar: CupertinoTabBar(
            backgroundColor: kMobileBackgroundColor,
            currentIndex: manager.currentIndex,
            onTap: (index) {
              manager.jumpToPage(index);
              _controller.jumpToPage(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "",
                backgroundColor: kPrimaryColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "",
                backgroundColor: kPrimaryColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle),
                label: "",
                backgroundColor: kPrimaryColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "",
                backgroundColor: kPrimaryColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "",
                backgroundColor: kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
