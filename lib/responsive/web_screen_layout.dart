import 'package:bhsoft_instagram_clone/models/models.dart';
import 'package:bhsoft_instagram_clone/providers/user_provider.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:bhsoft_instagram_clone/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _currentIndex = 0;

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  void selectPage(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

    setState(() {
      _currentIndex = index;
    });
  }

  final icons = [
    const Icon(Icons.home),
    const Icon(Icons.search),
    const Icon(Icons.add_circle),
    const Icon(Icons.favorite),
    const Icon(Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final User? user = Provider.of<UserProvider>(context).user;
    return Scaffold(
        backgroundColor: kwebBackgroundColor,
        appBar: AppBar(
          title: SvgPicture.asset(
            "assets/ic_instagram.svg",
            color: kprimaryColor,
          ),
          actions: icons.map((icon) {
            return IconButton(
              icon: icon,
              color: icons.indexOf(icon) == _currentIndex
                  ? kBlueColor
                  : kprimaryColor,
              onPressed: () {
                selectPage(icons.indexOf(icon));
              },
            );
          }).toList(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 4),
          child: user == null
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
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
        ));
  }
}
