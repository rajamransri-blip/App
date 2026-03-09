import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiProvider extends ChangeNotifier {
  // States
  bool isLoading = true;
  List<dynamic> items = [];
  
  // Settings
  bool isCommunityOn = false;
  bool showContactUs = true;
  String contactEmail = 'support@example.com';
  String aboutAppText = 'Islamic Collection App v1.0';
  
  // Updates
  String latestVersion = '1.0.0';
  String updateUrl = 'https://github.com/rajamransri-blip';
  String updateMessage = 'Update available!';

  ApiProvider() {
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      // 1. Fetch App Content (Duas/Ayahs)
      final dataRes = await http.get(Uri.parse('https://raw.githubusercontent.com/rajamransri-blip/IslamicAppData/main/data.json'));
      if (dataRes.statusCode == 200) {
        items = json.decode(dataRes.body);
      }

      // 2. Fetch Settings
      final settingsRes = await http.get(Uri.parse('https://raw.githubusercontent.com/rajamransri-blip/IslamicAppData/main/settings.json'));
      if (settingsRes.statusCode == 200) {
        final settings = json.decode(settingsRes.body);
        isCommunityOn = settings['communityEnabled'] ?? false;
        showContactUs = settings['showContactUs'] ?? true;
        contactEmail = settings['contactEmail'] ?? 'support@example.com';
        aboutAppText = settings['aboutAppText'] ?? 'Islamic Collection App';
      }

      // 3. Fetch Updates
      final updateRes = await http.get(Uri.parse('https://raw.githubusercontent.com/rajamransri-blip/IslamicAppData/main/update.json'));
      if (updateRes.statusCode == 200) {
        final updateData = json.decode(updateRes.body);
        latestVersion = updateData['latestVersion'] ?? '1.0.0';
        updateUrl = updateData['updateUrl'] ?? 'https://github.com/rajamransri-blip';
        updateMessage = updateData['forceUpdateMessage'] ?? 'Update available!';
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Local setting toggle for community
  void toggleCommunity(bool value) {
    isCommunityOn = value;
    notifyListeners();
  }
}
