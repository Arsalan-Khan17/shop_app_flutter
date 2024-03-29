import 'package:flutter/material.dart';
import 'package:shop_flutter/models/http_exception.dart';
import 'dart:convert';
import 'Product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  bool _showFavouritesOnly = false;

  Products(this.authToken, this._items, this.userId);
  Product findById(String id) {
    return items.firstWhere((product) => product.id == id);
  }

  final String? authToken;
  final String? userId;
  List<Product> get items {
    // if (_showFavouritesOnly) {
    //   return _items.where((product) => product.isFavourite).toList();
    // }
    return [..._items];
  }

  List<Product> get favouriteItems {
    return items.where((product) => product.isFavourite).toList();
  }
  //
  // void showFavouritesOnly() {
  //   _showFavouritesOnly = true;
  //   notifyListeners();
  // }
  //
  // void showAll() {
  //   _showFavouritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://shop-flutter-db673-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final favouriteproducts = await http.get(Uri.parse(
          'https://shop-flutter-db673-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken'));
      final favouriteData = json.decode(favouriteproducts.body);
      final List<Product> loadProducts = [];
      extractedData.forEach((prodId, prodKey) {
        loadProducts.add(Product(
            id: prodId.toString(),
            title: prodKey['title'],
            imageUrl: prodKey['imageUrl'],
            price: prodKey['price'],
            description: prodKey['description'],
            isFavourite: favouriteData == null
                ? false
                : favouriteData[prodId] ?? false));
        _items = loadProducts;
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) {
    final url =
        'https://shop-flutter-db673-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    return http
        .post(Uri.parse(url),
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl,
              'isFavourite': product.isFavourite,
              'creatorId': userId
            }))
        .then((response) {
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    var prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-flutter-db673-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print(prodIndex);
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-flutter-db673-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    var prodIndex = _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[prodIndex];
    _items.removeAt(prodIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode >= 400) {
      _items.insert(prodIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}
