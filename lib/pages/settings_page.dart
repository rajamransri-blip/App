import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/data_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _launchURL(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open link'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<DataProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), backgroundColor: Colors.transparent, elevation: 0),
      body: appData.isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.teal))
        : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildCard(
            isDark: isDark,
            child: ListTile(
              title: const Text('Community Feature', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Enable community tab on home'),
              trailing: CupertinoSwitch(
                value: appData.isCommunityOn,
                activeColor: Colors.teal,
                onChanged: (value) => appData.toggleCommunity(value),
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
                    showDialog(context: context, builder: (_) => AlertDialog(
                      title: const Text('About'),
                      content: Text(appData.aboutAppText),
                    ));
                  },
                ),
                const Divider(height: 1),
                if (appData.showContactUs)
                  ListTile(
                    leading: const Icon(CupertinoIcons.mail),
                    title: const Text('Contact Us'),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Contact: ${appData.contactEmail}'))),
                  ),
                if (appData.showContactUs) const Divider(height: 1),
                ListTile(
                  leading: const Icon(CupertinoIcons.cloud_download),
                  title: const Text('Check for Updates'),
                  subtitle: Text('Current: 1.0.0 | Latest: ${appData.latestVersion}'),
                  onTap: () {
                    if ('1.0.0' != appData.latestVersion) {
                      _launchURL(context, appData.updateUrl);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You are on the latest version!'), backgroundColor: Colors.teal));
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCard({required bool isDark, required Widget child}) {
    return Container(decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]), child: child);
  }
}
