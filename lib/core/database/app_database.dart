import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ecommerce/features/products/data/model/product_Model.dart';

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
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  // enforce relationships between tables (foregin keys)
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // formula creating multple tables under one database execution block
  Future _createDB(Database db, int version) async {
    // users tables
    await db.execute("""
      CREATE TABLE users(
      id TEXT PRIMARY KEY,
      email TEXT NOT NULL UNIQUE,
      password_hash  TEXT NOT NULL,
      name TEXT NOT NULL,
      created_at TEXT NOT NULL
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


  // AUTH /USER REGISTER AND LOGIN 

  Future<void> registerUser(Map<String, dynamic> userMap) async{
    final db = await database;
    await db.insert('users', userMap, conflictAlgorithm: ConflictAlgorithm.fail);
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



// for products operations

// 1 create product 
Future<void> insertProduct(ProductModel product) async{
  final db = await database;
  await db.insert(
    'products', product.toSql(),
    // enable this method for save and update product 
    conflictAlgorithm: ConflictAlgorithm.replace);
}


// fetch all products oreder by newest creation date
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

  }

