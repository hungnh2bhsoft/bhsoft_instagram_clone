import 'package:flutter/material.dart';

class PageManagerProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void jumpToPage(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
