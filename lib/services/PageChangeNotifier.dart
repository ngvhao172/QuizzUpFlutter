import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {
  int _page = 0;

  int get page => _page;

  void updateData(int page) {
    _page = page;
    notifyListeners();
  }
}