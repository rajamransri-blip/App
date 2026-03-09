import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/settings_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // URL Launch karne ka 100% working function
  Future<void> _launchURL(BuildContext context) async {
    final Uri url = Uri.parse('https://github.com/rajamransri-blip');
    
    try {
      // Ye command Android ko force karti hai external Chrome/Browser open karne ke liye
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Link open nahi ho pa raha hai.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildCard(
            isDark: isDark,
            child: ListTile(
              title: const Text('Community Feature', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Enable community tab on home'),
              trailing: CupertinoSwitch(
                value: settings.isCommunityOn,
                activeColor: Colors.teal,
                onChanged: (value) => settings.toggleCommunity(value),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildCard(
            isDark: isDark,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(CupertinoIcons.info_circle),
                  title: const Text('About App'),
                  onTap: () {
                    showDialog(context: context, builder: (_) => const AlertDialog(
                      title: Text('About'),
                      content: Text('Islamic Collection App v1.0\nDeveloped with Flutter.\nA peaceful app for daily Duas and Ayahs.'),
                    ));
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(CupertinoIcons.mail),
                  title: const Text('Contact Us'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contact: support@islamicapp.com')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(CupertinoIcons.cloud_download),
                  title: const Text('Check for Updates'),
                  // Yahan par function call ho raha hai
                  onTap: () => _launchURL(context), 
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCard({required bool isDark, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: child,
    );
  }
}
