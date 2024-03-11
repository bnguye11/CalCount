// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  final ScrollController controller = ScrollController();
  final PanelController panelController = PanelController();
  
  Food newlyAddedFood = Food(id: -1, name: "Temp", calories: 0, fat: 0, protein: 0, carb: 0);

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

  getDaily () async {
    var dailyList = await DatabaseHelper.instance.getFoods('dailyFoods');
    return dailyList;
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
      tempText = Text("${tempFood.name} added", style: TextStyle(color: Colors.white),);
    }

    return tempText;
  }

  Future <List<int>> getTotals() async{
    List<int> totals = [0, 0, 0, 0];
    var daily = await DatabaseHelper.instance.getFoods('dailyFoods');
    for(var i = 0; i < daily.length; i++){
      totals[0] += daily[i].calories;
      totals[1] += daily[i].protein;
      totals[2] += daily[i].fat;
      totals[3] += daily[i].carb;
      print(totals);
    }
    return totals;
  }

  @override
  Widget build(BuildContext context){
    var totals = getTotals();
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
                  var favFoods = await DatabaseHelper.instance.getFoods('favouriteFoods');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Favourites(favouriteFoods: favFoods,remove: removeFav,)
                    ),
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
        ),
      ),
      body: SlidingUpPanel(
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(0, 10, 0, 100),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  " - Overview -",
                  style: TextStyle(fontSize: 30, color:Colors.white),
                ),
                FutureBuilder <List<int>>(
                  future: getTotals(), 
                  builder: (context, snapshot){
                    if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                      if(snapshot.data != null){
                        return Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Image(
                                  height: 200,
                                  image: AssetImage("assets/images/calCircle.png"),
                                ),
                                Column(
                                  children: [
                                    Text("Calories", style: TextStyle(fontSize: 15, color:Colors.white)),
                                    Text("${snapshot.data?[0]} kcal", style: TextStyle(fontSize: 35, color:Colors.white)),
                                  ],
                                )
                              ]
                            ),
                            Container(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image(
                                      height: 80,
                                      image: AssetImage("assets/images/proteinCircle.png"),
                                    ),
                                    Column(
                                      children: [
                                        Text("Protein", style: TextStyle(fontSize: 10, color:Colors.white, )),
                                        Text("${snapshot.data?[1]} g", style: TextStyle(fontSize: 15, color:Colors.white)),
                                      ],
                                    ),
                                  ],
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image(
                                      height: 80,
                                      image: AssetImage("assets/images/fatCircle.png"),
                                    ),
                                    Column(
                                      children: [
                                        Text("Fats", style: TextStyle(fontSize: 10, color:Colors.white, )),
                                        Text("${snapshot.data?[2]} g", style: TextStyle(fontSize: 15, color:Colors.white)),
                                      ],
                                    ),
                                  ],
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image(
                                      height: 80,
                                      image: AssetImage("assets/images/carbCircle.png"),
                                    ),
                                    Column(
                                      children: [
                                        Text("Carbs", style: TextStyle(fontSize: 10, color:Colors.white, )),
                                        Text("${snapshot.data?[3]} g", style: TextStyle(fontSize: 15, color:Colors.white)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    }
                    return Text("If you see this, something broke", style: TextStyle(fontSize: 30, color:Colors.white));
                  }
                ),
                Container(height: 30,),
                Text(
                  " - History -",
                  style: TextStyle(fontSize: 30, color:Colors.white),
                ),
                setText(),
              ],
            ),
          ],
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
      ),
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
