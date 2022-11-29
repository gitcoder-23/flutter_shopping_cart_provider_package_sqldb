import 'package:flutter_shopping_cart_provider/models/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return null;
  }

  //
  initDatabase() async {
    //  to create path in mobile db as local Storage
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    // "cart.db"- created db name
    String path = join(documentDirectory.path, 'cart.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  //
  _onCreate(
    Database db,
    int Version,
  ) async {
    // create table
    await db.execute(
      'CREATE TABLE cart (id INTEGER PRIMARY KEY, productId VARCHAR UNIQUE, productName TEXT, initialPrice INTEGER, productPrice INTEGER, quantity INTEGER, unitTag TEXT, image TEXT)',
    );
  }

  // add value dummy
  Future<CartModel> insert(CartModel cart) async {
    print('test->${cart.toMap()}');
    var dbClient = await db;
    await dbClient?.insert('cart', cart.toMap());
    return cart;
  }

  // Get Cart List

  Future<List<CartModel>> getCartList() async {
    var dbClient = await db;
    if (dbClient != null) {
      final List<Map<String, Object?>> queryResult =
          await dbClient.query('cart');
      return queryResult.map((e) => CartModel.fromMap(e)).toList();
    } else {
      final List<Map<String, Object?>> queryResult =
          await dbClient!.query('cart');
      return queryResult.map((e) => CartModel.fromMap(e)).toList();
    }
  }

  // Delete Product From Cart
  Future<int> deleteProduct(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update Cart Quantity Cart

  Future<int> updateQuantity(CartModel cart) async {
    var dbClient = await db;
    return await dbClient!.update(
      // Table Name
      'cart',
      cart.toMap(),
      where: 'id = ?',
      whereArgs: [cart.id],
    );
  }
}
