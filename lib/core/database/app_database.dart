import 'dart:async';

import 'package:ecommerce/features/auth/data/model/user_model.dart';
import 'package:ecommerce/features/orders/data/model/order_item_model.dart';
import 'package:ecommerce/features/orders/data/model/order_model.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ecommerce/features/products/data/model/product_model.dart';

class AppDatabase {
  // singleton pattern (single point of entry)
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('app_database_v1.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
      onConfigure: _onConfigure,
    );
  }

  // enforce relationships between tables (foregin keys)
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // formula creating  tables under one database execution block
  Future _createDB(Database db, int version) async {
    // users tables
    await db.execute("""
      CREATE TABLE users(
      id TEXT PRIMARY KEY,
      email TEXT NOT NULL UNIQUE,
      password_hash  TEXT NOT NULL,
      name TEXT NOT NULL,
      created_at TEXT NOT NULL
      ,profile_image_path TEXT
      )
""");

// PRODUCT TABLE 
  await db.execute(''' 
  CREATE TABLE products(
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  price REAL NOT NULL,
  image_url TEXT NOT NULL,
  category TEXT NOT NULL,
  created_at TEXT NOT NULL
  )
  ''');

  // ORDER TABLE
  await db.execute('''
    CREATE TABLE orders ( 
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    total_amount real NOT NULL,
    status TEXT NOT NULL,
    created_at TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
    )
''');

await db.execute('''
  CREATE TABLE order_items( 
    id TEXT PRIMARY KEY,
    order_id TEXT NOT NULL,
    product_id TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    price_at_purchase REAL NOT NULL, 
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE RESTRICT
  )
''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE users ADD COLUMN profile_image_path TEXT',
      );
    }
  }


  // AUTH /USER REGISTER AND LOGIN
  // get all users
  Future<List<UserModel>> getAllUsers() async {
  final db = await database;

  debugPrint('========== SQLITE READ START ==========');
  debugPrint('READ DATABASE PATH: ${db.path}');

  final maps = await db.query('users');

  debugPrint('READ RESULT COUNT: ${maps.length}');

  return maps.map((row) => UserModel.fromSql(row)).toList();
}

 Future<void> registerUser(
  Map<String, dynamic> userMap,
) async {
  final db = await database;

  debugPrint('========== SQLITE INSERT START ==========');
  debugPrint('DATABASE PATH: ${db.path}');
  debugPrint('TABLE: users');
  debugPrint('COLUMN NAMES: ${userMap.keys.toList()}');

  try {
    final id = await db.insert(
      'users',
      userMap,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    debugPrint('INSERT SUCCESS. ID: $id');

    final rows = await db.query('users');

    debugPrint('ROWS IMMEDIATELY AFTER INSERT: ${rows.length}');
    debugPrint('========== SQLITE INSERT END ==========');
  } catch (error) {
    debugPrint('SQLITE INSERT FAILED: $error');
    // debugPrintStack(stackTrace: stackTrace);
    rethrow;
  }
}
  
  Future<Map<String, dynamic>?> loginUser(String email, String password) async{
    final db = await database;
    final res = await db.query(
      'users',
      where: 'email = ? AND password_hash = ?',
      whereArgs: [email, password]
    );
    return res.isNotEmpty ? res.first : null;
  }

  Future<void> updateUser({
    required String id,
    required String name,
    required String email,
    String? profileImagePath,
  }) async {
    final db = await database;
    await db.update(
      'users',
      {
        'name': name,
        'email': email,
        'profile_image_path': profileImagePath,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }



// ** for products operations

Future<void> seedProducts(List<ProductModel> products) async {
  final db = await database;

  final batch = db.batch();

  for (final product in products) {
    batch.insert(
      'products',
      product.toSql(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  await batch.commit(noResult: true);
}
// 1 create product 
Future<void> insertProduct(ProductModel product) async{
  final db = await database;
  await db.insert(
    'products', product.toSql(),
    // enable this method for save and update product 
    conflictAlgorithm: ConflictAlgorithm.replace);
}


// fetch all products order by newest creation date
Future <List<ProductModel>> fetchAllProducts() async{
  final db = await database;

  final result = await db.query('products', orderBy: 'created_at DESC');
  return result.map((json) => ProductModel.formSql(json)).toList();
}

Future <ProductModel?> fetchProductById( String id) async{
  final db = await database; 
  final maps = await db.query(  
    'products',
    where: 'id = ?',
    whereArgs: [id],
  );
  if(maps.isNotEmpty){
    return ProductModel.formSql(maps.first);
  }else{
    return null ; 
  }
}

Future<int> updateProduct(ProductModel product) async{
  final db = await database;

  return await db.update(
    'products',
    product.toSql(),
    where: 'id = ?',
    whereArgs: [product.productId]
   );
}

Future<int> deleteProduct(String id) async{
  final db = await database;

  return await db.delete('products', where: 'id = ?',whereArgs: [id]);
}

Future close() async{
  final db = await database;
  db.close();
}



// ** Order feature  
Future <void> createOrder(OrderModel order) async          {

  final db = await database;
  await db.transaction((txn) async{
    await txn.insert('orders', 
    order.toDbMap(),
    conflictAlgorithm: ConflictAlgorithm.fail);

     for (final item in order.items){
      final itemModel = item as OrderItemModel;
      await txn.insert(
        'order_items', 
        itemModel.toDbMap(order.id),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }
  });
}
Future<List<OrderModel>> getAllOrders(String userId) async {
  final db = await database;

  final orderMaps = await db.query(
    'orders',
   where: 'user_id = ?',
   whereArgs: [userId],
   orderBy: 'created_at DESC',
 );

  if (orderMaps.isEmpty) return [];

  final List<OrderModel> completeOrders = [];

  for (final orderMap in orderMaps) {
    final String orderId = orderMap['id'] as String;

    final itemMaps = await db.query(
      'order_items',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );

    final fullOrder = OrderModel.fromSql(
      orderMap,
      itemMaps,
    );

    completeOrders.add(fullOrder);
  }

  return completeOrders;
}
}