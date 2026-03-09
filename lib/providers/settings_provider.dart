import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isCommunityOn = false;

  bool get isCommunityOn => _isCommunityOn;

  void toggleCommunity(bool value) {
    _isCommunityOn = value;
    notifyListeners();
  }
}
