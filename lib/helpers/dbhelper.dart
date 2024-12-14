import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import '../models/product.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static sql.Database? _database;

  DBHelper._init();

  Future<sql.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('products.db');
    return _database!;
  }

  Future<sql.Database> _initDB(String filePath) async {
    final dbPath = await sql.getDatabasesPath();
    final fullPath = path.join(dbPath, filePath);

    try {
      return await sql.openDatabase(
        fullPath,
        version: 1,
        onCreate: _createDB,
      );
    } catch (e) {
      throw Exception('Error initializing database: $e');
    }
  }

  Future<void> _createDB(sql.Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sku TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        discounted_price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        manufacturer TEXT NOT NULL,
        image_url TEXT NOT NULL
      )
    ''');
  }

  Future<Product> create(Product product) async {
    try {
      final db = await instance.database;
      final id = await db.insert('products', product.toMap());
      return product.copyWith(id: id);
    } catch (e) {
      throw Exception('Error creating product: $e');
    }
  }

  Future<List<Product>> getAllProducts() async {
    try {
      final db = await instance.database;
      final result = await db.query('products');
      return result.map((json) => Product.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<int> update(Product product) async {
    try {
      final db = await instance.database;
      return db.update(
        'products',
        product.toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  Future<int> delete(int id) async {
    try {
      final db = await instance.database;
      return await db.delete(
        'products',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}
