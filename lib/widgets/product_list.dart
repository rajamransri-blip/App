import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/data_provider.dart';
import 'package:shop_app_flutter/pages/product_details_page.dart';
import 'package:shop_app_flutter/pages/settings_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String selectedCategory = 'All';
  String searchQuery = '';
  final List<String> categories = ['All', 'Duas', 'Namaz ka tarika', 'Ayah'];

  Widget _errorIcon(bool isDark) => Container(
    height: 150,
    color: isDark ? Colors.grey[800] : Colors.grey[300],
    child: const Icon(CupertinoIcons.photo, size: 50, color: Colors.grey),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appData = Provider.of<DataProvider>(context);

    final filteredProducts = appData.items.where((p) {
      final matchesCategory = selectedCategory == 'All' || p['category'] == selectedCategory;
      final matchesSearch = p['title'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Islamic\nCollection', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(CupertinoIcons.settings, size: 30),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: CupertinoSearchTextField(
              placeholder: 'Search content...',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: Colors.teal,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: (selected) => setState(() => selectedCategory = category),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: appData.isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.teal))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsPage(product: product))),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                child: Image.asset(product['imageUrl'] ?? '', height: 150, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => _errorIcon(isDark)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product['title'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 5),
                                    Text(product['shortDescription'] ?? '', style: TextStyle(fontSize: 14, color: isDark ? Colors.grey[400] : Colors.grey[600])),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
