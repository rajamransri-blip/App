import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context).cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Items'),
      ),
      body: cart.isEmpty
          ? const Center(
              child: Text(
                'No saved items yet.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final cartItem = cart[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.bookmark, color: Colors.white),
                  ),
                  title: Text(
                    cartItem['title'].toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  subtitle: Text(cartItem['category'].toString()),
                  trailing: IconButton(
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .removeProduct(cartItem);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                );
              },
            ),
    );
  }
}
