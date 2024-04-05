import 'package:calcount/barDisplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:calcount/panel.dart';
import 'package:calcount/food_model.dart';
import 'package:calcount/favourites.dart';
import 'package:calcount/settings.dart';
import 'databasehelper.dart';

import 'package:cron/cron.dart';

void clearFoodsDaily() {
  final cron = Cron();

  //This should reset everyday but im not sure if it works if its not in the background or foreground
  //we could switch to something like firebase but that kinda defeats the purpose of this app and also we already did most of the work in sqlflite
  // saves data before clearing it;
  //should now run at 11:59pm
  cron.schedule(Schedule.parse('59 23 * * *'), () async {
    print("cleared");
    //lets use dummy data for now;
    var currentTime = DateTime.now();
    
    List<double> totals = [0, 0, 0, 0];
    var daily = await DatabaseHelper.instance.getFoods('dailyFoods');
    for (var i = 0; i < daily.length; i++) {
      totals[0] += daily[i].calories;
      totals[1] += daily[i].protein;
      totals[2] += daily[i].fat;
      totals[3] += daily[i].carb;
      //print(totals);
    }
    var storedDaily = {
      'date': '${currentTime.year}-${currentTime.month}-${currentTime.day}',
      'calories': totals[0],
      'protein': totals[1],
      'fat': totals[2],
      'carb': totals[3],
    };

    await DatabaseHelper.instance.addHistory(storedDaily);
    await DatabaseHelper.instance.clearTable('dailyFoods');

    print("donzo");
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  clearFoodsDaily();
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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 59, 113, 254)),
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

  Food newlyAddedFood =
      Food(id: -1, name: "Temp", calories: 0, fat: 0, protein: 0, carb: 0);

  //Temp storage for current calories
  double currentCalorie = 0;

  //dummy data for calories
  List<double> weeklyCalories = [
    3000,
    2504.2,
    2750,
    2000,
    1254.34,
    3852,
    4000,
  ];


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

  Future<List<Food>> getDaily() async {
    return await DatabaseHelper.instance.getFoods('dailyFoods');
  }

  getFavourite() async {
    return await DatabaseHelper.instance.getFoods('favouriteFoods');
  }

  removeFav(id, dbName) async {
    await DatabaseHelper.instance.remove(id, dbName);
  }

  Text setText() {
    Text tempText;
    Food tempFood = newlyAddedFood;

    if (tempFood.id == -1) {
      tempText = const Text(
        "no new food added :(",
        style: TextStyle(color: Colors.white),
      );
    } else {
      tempText = Text(
        "${tempFood.name} added",
        style: TextStyle(color: Colors.white),
      );
    }

    return tempText;
  }

  Future<List<double>> getTotals() async {
    //Hijacked function to also include the goals from profile, they are in index 4-7
    List<double> totals = [0, 0, 0, 0 , 0, 0, 0, 0];
    var profile = await DatabaseHelper.instance.getProfile();
    var daily = await DatabaseHelper.instance.getFoods('dailyFoods');
    for (var i = 0; i < daily.length; i++) {
      totals[0] += daily[i].calories;
      totals[1] += daily[i].protein;
      totals[2] += daily[i].fat;
      totals[3] += daily[i].carb;
      print(totals);
    }
    totals[4] = profile.calories;
    totals[5] = profile.protein;
    totals[6] = profile.fat;
    totals[7] = profile.carb;
    return totals;
  }

  Future<List<double>> getGoals() async {
    List<double> goals = [0, 0, 0, 0];
    
    

    return goals;
  }

  void setCurrentCal () async {
    var totals = await getTotals();
    setState(() {
      currentCalorie = totals[0];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCurrentCal();
  }

  

  @override
  Widget build(BuildContext context) {
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.8;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
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
                onTap: ()  {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Favourites()),
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
                  "- Overview -",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                SizedBox(height: 10),
                FutureBuilder<List<double>>(
                    future: getTotals(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data != null) {
                          return Column(
                            children: [
                              Stack(alignment: Alignment.center, children: [
                                SizedBox(
                                  width: 225,
                                  height: 225,
                                  child: CircularProgressIndicator(
                                    color: Color.fromARGB(255, 222, 107, 0),
                                    backgroundColor: Color.fromARGB(255, 217, 217, 217),
                                    value: snapshot.data![0] / snapshot.data![4],
                                    strokeWidth: 15,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text("Calories",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white)),
                                    Text("${snapshot.data?[0]} kcal",
                                        style: TextStyle(
                                            fontSize: 35, color: Colors.white)),
                                  ],
                                )
                              ]),
                              Container(height: 40),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        height: 90,
                                        child: CircularProgressIndicator(
                                          color: Color.fromARGB(255, 244, 67, 54),
                                          backgroundColor: Color.fromARGB(255, 217, 217, 217),
                                          value: snapshot.data![1] / snapshot.data![5],
                                          strokeWidth: 7,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text("Protein",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              )),
                                          Text("${snapshot.data?[1]} g",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        height: 90,
                                        child: CircularProgressIndicator(
                                          color: Color.fromARGB(255, 33, 150, 243),
                                          backgroundColor: Color.fromARGB(255, 217, 217, 217),
                                          value: snapshot.data![2] / snapshot.data![6],
                                          strokeWidth: 7,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text("Fats",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              )),
                                          Text("${snapshot.data?[2]} g",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        height: 90,
                                        child: CircularProgressIndicator(
                                          color: Color.fromARGB(255, 255, 235, 59),
                                          backgroundColor: Color.fromARGB(255, 217, 217, 217),
                                          value: snapshot.data![3] / snapshot.data![7],
                                          strokeWidth: 7,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text("Carbs",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              )),
                                          Text("${snapshot.data?[3]} g",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white)),
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
                      return Column(
                        children: [
                          Text(
                            "Please go to Profile and enter your Information\nto see Overview",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 20,),
                          CircularProgressIndicator(),
                        ]
                      );
                    }),
                Container(
                  height: 40,
                ),
                FloatingActionButton.extended(
                  label: Text("Add Food"),
                  heroTag: "btn1",
                  onPressed: () {
                    panelController.open();
                  },
                  // child: const Icon(Icons.add),
                ),
                Container(
                  height: 30,
                ),
                BarDisplay(currentCalorie: currentCalorie, weeklyCalories: weeklyCalories,),
                const Text(
                  " - History -",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                FutureBuilder<List<Food>>(
                    future: getDaily(),
                    builder: (context, ssDaily) {
                      if (ssDaily.hasData &&
                          ssDaily.connectionState == ConnectionState.done) {
                        print(ssDaily.data);
                        return Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(), 
                            itemCount: ssDaily.data!.length,
                            itemBuilder: (context, index) {
                              Food currentFood = ssDaily.data![index];
                              return Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "${currentFood.name} - cal: ${currentFood.calories}kcal / P:${currentFood.protein}g / F:${currentFood.fat}g / C:${currentFood.carb}g",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
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
            updateCurrentCal: setCurrentCal,
          );
        },
      ),
    );
  }
}
