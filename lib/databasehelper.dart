import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:calcount/food_model.dart';
import 'package:calcount/profile.dart';

//this could probably be moved to its own separate file but keeping it here for now
//        'CREATE TABLE dailyFoods(id INTEGER PRIMARY KEY, name TEXT, calories INTEGER, protein INTEGER, fat INTEGER, carb INTEGER)',

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  static Database? _favouriteDB;
  static Database? _profileDB;
  static Database? _historyDB;

  Future<Database> get database async => _database ??= await _initDatabase();
  Future<Database> get favouriteDB async =>
      _favouriteDB ??= await _initFavDatabase();
  Future<Database> get profileDB async =>
      _profileDB ??= await _initProfileDatabase();
  Future<Database> get historyDB async =>
      _historyDB ??= await _initHistoryDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'dailyFoods.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<Database> _initFavDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'favourite.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateFav,
    );
  }

  Future<Database> _initProfileDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'profile.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateProfile,
    );
  }

  Future<Database> _initHistoryDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'history.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateHistory,
    );
  }

  //these could maybe be combined into a single function
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dailyFoods(
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        calories REAL, 
        protein REAL, 
        fat REAL, 
        carb REAL)
      ''');
  }

  Future _onCreateFav(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favouriteFoods(
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        calories REAL, 
        protein REAL, 
        fat REAL, 
        carb REAL)
      ''');
  }

  Future _onCreateProfile(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favouriteFoods(
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        age INTEGER, 
        gender TEXT, 
        weight REAL, 
        height REAL)
      ''');
  }

  Future _onCreateHistory(Database db, int version) async {
    //date might not be necessary since I think it autotimestamps info when you add it to the db
    await db.execute('''
      CREATE TABLE history(
        id INTEGER PRIMARY KEY, 
        date TEXT, 
        calories REAL, 
        protein REAL, 
        fat REAL, 
        carb REAL)
      ''');
  }

  Future<List<Food>> getFoods(String dbName) async {
    Database db;
    if (dbName == "dailyFoods") {
      db = await instance.database;
    } else {
      db = await instance.favouriteDB;
    }

    var foods = await db.query(dbName, orderBy: 'name');
    List<Food> foodList =
        foods.isNotEmpty ? foods.map((c) => Food.fromMap(c)).toList() : [];
    return foodList;
  }

  Future<int> add(Food food, String dbName) async {
    Database db;
    if (dbName == "dailyFoods") {
      db = await instance.database;
    } else {
      db = await instance.favouriteDB;
    }
    print("here is food structure");
    print(food.toMap());
    return await db.insert(dbName, food.toMap());
  }

  Future removeLatest(String dbName) async {
    Database db;
    if (dbName == "dailyFoods") {
      db = await instance.database;
    } else {
      db = await instance.favouriteDB;
    }

    return await db.execute(
        'DELETE FROM $dbName WHERE id = (SELECT MAX(id) FROM $dbName)');
  }

  Future clearTable(String dbName) async {
    Database db;
    if (dbName == "dailyFoods") {
      db = await instance.database;
    } else {
      db = await instance.favouriteDB;
    }

    return await db.execute('DELETE FROM $dbName');
  }

  Future<int> remove(int id, String dbName) async {
    Database db;
    if (dbName == "dailyFoods") {
      db = await instance.database;
    } else {
      db = await instance.favouriteDB;
    }
    return await db.delete(dbName, where: 'id = ?', whereArgs: [id]);
  }

  Future<Profile> getProfile() async {
    Database db = await instance.profileDB;

    var proQuery = await db.query("profile");
    List<Profile> profile = proQuery.isNotEmpty
        ? proQuery.map((c) => Profile.fromMap(c)).toList()
        : [];
    // List<Food> foodList = foods.isNotEmpty ? foods.map((c) => Food.fromMap(c)).toList() : [];
    return profile[0];
  }
}
