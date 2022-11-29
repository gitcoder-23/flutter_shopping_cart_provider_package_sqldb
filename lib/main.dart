import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_provider/providerState/cart_provider.dart';
import 'package:flutter_shopping_cart_provider/screens/product_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Add Provider Globally
    return ChangeNotifierProvider(
      // call provider file
      create: (_) => CartProvider(),
      child: Builder(builder: (BuildContext context) {
        //  Then Material App of main dart
        return MaterialApp(
          title: 'Shopping Cart Using Flutter & Provider Package',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          home: const ProductList(title: 'Product List'),
        );
      }),
    );
  }
}
