import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter/providers/orders.dart';

import '../providers/cart.dart' show Cart;
import 'package:shop_flutter/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(), cart.totalAmount);
                      cart.clearCart();
                    },
                    child: Text('ORDER NOW'),
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.primary)),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.item_count,
                  itemBuilder: (ctx, index) => CartItem(
                        id: cart.items.values.toList()[index].id,
                        title: cart.items.values.toList()[index].title,
                        quantity: cart.items.values.toList()[index].quantity,
                        price: cart.items.values.toList()[index].price,
                        productId: cart.items.keys.toList()[index],
                      )))
        ],
      ),
    );
  }
}
