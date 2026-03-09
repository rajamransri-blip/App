import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/pages/cart_page.dart';
import 'package:shop_app_flutter/pages/community_page.dart';
import 'package:shop_app_flutter/providers/data_provider.dart';
import 'package:shop_app_flutter/widgets/product_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final isCommunityOn = Provider.of<DataProvider>(context).isCommunityOn;

    if (!isCommunityOn && currentPage == 2) {
      currentPage = 0;
    }

    List<Widget> pages = [
      const ProductList(),
      const CartPage(),
      if (isCommunityOn) const CommunityPage(),
    ];

    List<BottomNavigationBarItem> navItems = [
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.book), label: 'Read'),
      const BottomNavigationBarItem(icon: Icon(CupertinoIcons.bookmark), label: 'Saved'),
      if (isCommunityOn)
        const BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_3), label: 'Community'),
    ];

    return Scaffold(
      body: IndexedStack(index: currentPage, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 28,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 10,
        onTap: (value) => setState(() => currentPage = value),
        currentIndex: currentPage,
        items: navItems,
      ),
    );
  }
}
