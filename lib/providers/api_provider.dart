import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiProvider extends ChangeNotifier {
  bool isLoading = true;
  List<dynamic> items = [];
  
  bool isCommunityOn = false;
  bool showContactUs = true;
  String contactEmail = 'support@islamicapp.com';
  String aboutAppText = 'Islamic Collection App v1.0\nDeveloped by Raaz.';
  
  String latestVersion = '1.0.0';
  String updateUrl = 'https://github.com/rajamransri-blip';

  ApiProvider() {
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      // 1. Fetch Content
      final dataRes = await http.get(Uri.parse('https://raw.githubusercontent.com/rajamransri-blip/IslamicAppData/main/data.json'));
      if (dataRes.statusCode == 200) {
        final parsed = json.decode(dataRes.body);
        // Crash se bachne ka safety check:
        if (parsed is List) {
          items = parsed;
        } else {
          _loadDefaultData(); 
        }
      } else {
        _loadDefaultData();
      }

      // 2. Fetch Settings
      final settingsRes = await http.get(Uri.parse('https://raw.githubusercontent.com/rajamransri-blip/IslamicAppData/main/settings.json'));
      if (settingsRes.statusCode == 200) {
        final settings = json.decode(settingsRes.body);
        isCommunityOn = settings['communityEnabled'] ?? false;
        showContactUs = settings['showContactUs'] ?? true;
        contactEmail = settings['contactEmail'] ?? 'support@islamicapp.com';
        aboutAppText = settings['aboutAppText'] ?? 'Islamic Collection App';
      }

      // 3. Fetch Updates
      final updateRes = await http.get(Uri.parse('https://raw.githubusercontent.com/rajamransri-blip/IslamicAppData/main/update.json'));
      if (updateRes.statusCode == 200) {
        final updateData = json.decode(updateRes.body);
        latestVersion = updateData['latestVersion'] ?? '1.0.0';
        updateUrl = updateData['updateUrl'] ?? 'https://github.com/rajamransri-blip';
      }
    } catch (e) {
      debugPrint("Network Error: $e");
      _loadDefaultData();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _loadDefaultData() {
    items = [
      {
        'id': '0',
        'title': 'Ayatul Kursi',
        'shortDescription': 'The Verse of the Throne',
        'arabic': 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ...',
        'translation': 'Allah! There is no deity except Him...',
        'category': 'Ayah',
        'imageUrl': 'assets/images/ayah.png',
      }
    ];
  }

  void toggleCommunity(bool value) {
    isCommunityOn = value;
    notifyListeners();
  }
}
