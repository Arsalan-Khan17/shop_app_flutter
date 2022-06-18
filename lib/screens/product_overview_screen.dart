import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter/screens/cart_screen.dart';
import 'package:shop_flutter/widgets/badge.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/product_grid.dart';

enum filterOptions { favourite, all }

class ProductOverviewScreen extends StatefulWidget {
  ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavourite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
              onSelected: (filterOptions selectedVal) {
                setState(() {
                  if (selectedVal == filterOptions.favourite) {
                    _showOnlyFavourite = true;
                  } else {
                    _showOnlyFavourite = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      child: Text('Only Favourites'),
                      value: filterOptions.favourite,
                    ),
                    const PopupMenuItem(
                      child: Text('Show All'),
                      value: filterOptions.all,
                    )
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(child: ch as Widget, value: cart.item_count.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: ProductGrid(_showOnlyFavourite),
    );
  }
}
