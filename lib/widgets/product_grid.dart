import 'package:flutter/material.dart';
import 'package:shop_flutter/providers/products.dart';
import 'package:shop_flutter/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../providers/Product.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;

  const ProductGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavs ? productsData.favouriteItems : productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: ProductItem(),
            ));
  }
}
