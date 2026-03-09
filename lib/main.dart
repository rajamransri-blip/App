import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/providers/cart_provider.dart';
import 'package:shop_app_flutter/providers/data_provider.dart'; // Naya provider
import 'package:shop_app_flutter/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()), // Data Provide kiya
      ],
      child: MaterialApp(
        title: 'Islamic Collection',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.light),
          scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
          scaffoldBackgroundColor: const Color(0xFF121212),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
