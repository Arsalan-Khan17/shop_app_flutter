import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter/providers/auth.dart';
import 'package:shop_flutter/providers/cart.dart';
import 'package:shop_flutter/providers/orders.dart';
import 'package:shop_flutter/screens/auth-screen.dart';
import 'package:shop_flutter/screens/cart_screen.dart';
import 'package:shop_flutter/screens/edit_product_screen.dart';
import 'package:shop_flutter/screens/orders_screen.dart';
import 'package:shop_flutter/screens/product_detail_screen.dart';
import 'package:shop_flutter/screens/product_overview_screen.dart';
import 'package:shop_flutter/screens/user_products_screen.dart';
import 'providers/products.dart';
import './screens/orders_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products(
                Provider.of<Auth>(context, listen: false).token,
                [],
                Provider.of<Auth>(context, listen: false).userId),
            update: (context, auth, previousProducts) => Products(
                auth.token,
                previousProducts == null ? [] : previousProducts.items,
                auth.userId),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders(
                Provider.of<Auth>(context, listen: false).token,
                [],
                Provider.of<Auth>(context, listen: false).userId),
            update: (context, auth, previousOrder) => Orders(auth.token,
                previousOrder == null ? [] : previousOrder.orders, auth.userId),
          ),
        ],
        child: Consumer<Auth>(builder: ((context, auth, child) {
          return MaterialApp(
            title: 'My Shop',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                fontFamily: 'Lato',
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                        .copyWith(secondary: Colors.deepOrange)),
            home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen()
            },
          );
        })));
  }
}
