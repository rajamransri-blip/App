import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context).cart;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Items'), backgroundColor: Colors.transparent, elevation: 0),
      body: cart.isEmpty
          ? const Center(child: Text('No saved items yet.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.teal.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(CupertinoIcons.book, color: Colors.teal),
                    ),
                    title: Text(item['title'].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item['category'].toString()),
                    trailing: IconButton(
                      onPressed: () => Provider.of<CartProvider>(context, listen: false).removeProduct(item),
                      icon: const Icon(CupertinoIcons.delete, color: Colors.red),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
