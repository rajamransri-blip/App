import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Local assets read karne ke liye

class DataProvider extends ChangeNotifier {
  bool isLoading = true;
  List<dynamic> items = [];
  
  bool isCommunityOn = false;
  bool showContactUs = true;
  String contactEmail = 'support@islamicapp.com';
  String aboutAppText = 'Islamic Collection App v1.0';
  
  String latestVersion = '1.0.0';
  String updateUrl = 'https://github.com/rajamransri-blip';

  DataProvider() {
    loadLocalData();
  }

  Future<void> loadLocalData() async {
    try {
      // Asset folder se data.json read kar rahe hain
      final String response = await rootBundle.loadString('assets/data.json');
      final data = json.decode(response);

      // 1. Settings set karein
      if (data['settings'] != null) {
        isCommunityOn = data['settings']['communityEnabled'] ?? false;
        showContactUs = data['settings']['showContactUs'] ?? true;
        contactEmail = data['settings']['contactEmail'] ?? 'support@example.com';
        aboutAppText = data['settings']['aboutAppText'] ?? 'App Details';
      }

      // 2. Update info set karein
      if (data['update'] != null) {
        latestVersion = data['update']['latestVersion'] ?? '1.0.0';
        updateUrl = data['update']['updateUrl'] ?? 'https://github.com/rajamransri-blip';
      }

      // 3. Items (Duas/Ayahs) set karein
      if (data['items'] != null) {
        items = data['items'];
      }
    } catch (e) {
      debugPrint("Error reading JSON: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleCommunity(bool value) {
    isCommunityOn = value;
    notifyListeners();
  }
}
