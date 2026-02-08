import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/wishlist_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wishlist.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE wishlist (
  id $idType,
  productId $integerType,
  name $textType,
  price $doubleType,
  imageUrl $textType,
  category $textType
)
''');
  }

  Future<int> create(WishlistItem item) async {
    final db = await instance.database;
    final id = await db.insert(
      'wishlist',
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<WishlistItem?> readWishlistItem(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'wishlist',
      columns: ['id', 'productId', 'name', 'price', 'imageUrl', 'category'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return WishlistItem.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<WishlistItem>> readAllWishlistItems() async {
    final db = await instance.database;
    final result = await db.query('wishlist');
    return result.map((json) => WishlistItem.fromJson(json)).toList();
  }

  Future<int> delete(int productId) async {
    final db = await instance.database;
    return await db.delete(
      'wishlist',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<bool> isFavorite(int productId) async {
    final db = await instance.database;
    final result = await db.query(
      'wishlist',
      where: 'productId = ?',
      whereArgs: [productId],
    );
    return result.isNotEmpty;
  }
}
