import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter/widgets/app_drawer.dart';
import 'package:shop_flutter/widgets/order_item.dart';

import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Screen'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
          itemCount: ordersData.orders.length,
          itemBuilder: (ctx, i) => OrderItem(ordersData.orders[i])),
    );
  }
}
