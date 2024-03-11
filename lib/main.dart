import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:calcount/panel.dart';
import 'package:calcount/food_model.dart';
import 'package:calcount/favourites.dart';
import 'package:calcount/settings.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cal Counter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        canvasColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 59, 113, 254)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cal Counter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;
  final ScrollController controller = ScrollController();
  final PanelController panelController = PanelController();
  
  Food newlyAddedFood =
      Food(id: -1, name: "Temp", calories: 0, fat: 0, protein: 0, carb: 0);

  callback(updatedFood) async {
    setState(() {
      newlyAddedFood = updatedFood;
    });

    await DatabaseHelper.instance.add(newlyAddedFood, 'dailyFoods');
    print("added!");
    print(newlyAddedFood.toString());
    var beans = await DatabaseHelper.instance.getFoods('dailyFoods');
    print("heres what in here so far");
    //print(beans);
    for (var i = 0; i < beans.length; i++) {
      print(beans[i].name);
    }
  }

  saveFavouriteFood(food) async {
    await DatabaseHelper.instance.add(food, 'favouriteFoods');
    print("favoruite food added!");
    var beans = await DatabaseHelper.instance.getFoods('favouriteFoods');
    print("heres what in here so far");
    for (var i = 0; i < beans.length; i++) {
      print(beans[i].name);
    }
  }

  removeLatest() async {
    await DatabaseHelper.instance.removeLatest('favouriteFoods');
    var beans = await DatabaseHelper.instance.getFoods('favouriteFoods');
    print("heres what in here so far");
    for (var i = 0; i < beans.length; i++) {
      print(beans[i].name);
    }
  }

  getFavourite () async {
    return await DatabaseHelper.instance.getFoods('favouriteFoods');
  }

  removeFav (id, dbName) async {
    await DatabaseHelper.instance.remove(id, dbName);
  }

  Text setText() {
    Text tempText;
    Food tempFood = newlyAddedFood;

    if (tempFood.id == -1) {
      tempText = const Text("no new food added :(", style: TextStyle(color: Colors.white),);
    } else {
      tempText = Text(tempFood.name, style: TextStyle(color: Colors.white),);
    }

    return tempText;
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.8;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.title, style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: Container(
          color: Color.fromARGB(200, 0, 0, 0),
          child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 59, 113, 254),
              ),
              child: Text(
                'Cal Counter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                ),
              ),
            ),
            ListTile(
              textColor: Colors.white,
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              textColor: Colors.white,
              title: const Text('Favourites'),
              onTap: () async {
                var favFoods =
                    await DatabaseHelper.instance.getFoods('favouriteFoods');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Favourites(favouriteFoods: favFoods,remove: removeFav,)),
                );
              },
            ),
            ListTile(
              textColor: Colors.white,
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            ),
          ],
                ),
        )),
      body: SlidingUpPanel(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              setText(),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              
            ],
          ),
        ),
        controller: panelController,
        maxHeight: panelHeightOpen,
        defaultPanelState: PanelState.CLOSED,
        minHeight: 0,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        backdropTapClosesPanel: true,
        //panel: ,
        panelBuilder: (controller) {
          return Panel(
            controller: controller,
            panelController: panelController,
            callback: callback,
            saveFavourite: saveFavouriteFood,
            removeLatest: removeLatest,
            favouriteList: getFavourite,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        onPressed: () {
          panelController.open();
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//this could probably be moved to its own separate file but keeping it here for now
//        'CREATE TABLE dailyFoods(id INTEGER PRIMARY KEY, name TEXT, calories INTEGER, protein INTEGER, fat INTEGER, carb INTEGER)',

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  static Database? _favouriteDB;
  static Database? _profileDB;

  Future<Database> get database async => _database ??= await _initDatabase();
  Future<Database> get favouriteDB async => _favouriteDB ??= await _initFavDatabase();
  Future<Database> get profileDB async => _profileDB ??= await _initProfileDatabase();

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

  //these could maybe be combined into a single function
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dailyFoods(
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        calories INTEGER, 
        protein INTEGER, 
        fat INTEGER, 
        carb INTEGER)
      ''');
  }

  Future _onCreateFav(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favouriteFoods(
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        calories INTEGER, 
        protein INTEGER, 
        fat INTEGER, 
        carb INTEGER)
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

  Future<int> remove(int id, String dbName) async {
    Database db;
    if (dbName == "dailyFoods") {
      db = await instance.database;
    } else {
      db = await instance.favouriteDB;
    }
    return await db.delete(dbName, where: 'id = ?', whereArgs: [id]);
  }
}
