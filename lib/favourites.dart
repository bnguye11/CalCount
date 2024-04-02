import 'package:flutter/material.dart';

import 'package:calcount/main.dart';
import 'package:calcount/settings.dart';
import 'package:calcount/food_model.dart';

import 'databasehelper.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List<Food> favouriteFoods = [];

  void setFavourite() async {
    var temp = await DatabaseHelper.instance.getFoods('favouriteFoods');
    setState(() {
      favouriteFoods = temp;
    });
  }

  removeFav(id, dbName) async {
    await DatabaseHelper.instance.remove(id, dbName);
  }

  @override
  initState() {
    super.initState();
    setFavourite();
  }

  @override
  Widget build(BuildContext context) {
    //for (var i = 0; i < favouriteFoods.length; i++) {
    //print(favouriteFoods[i].name);
    //}

    List<Widget> getGrid() {
      var items = <Widget>[];
      for (var i = 0; i < favouriteFoods.length; i++) {
        items.add(InkWell(
          child: Container(
              padding: const EdgeInsets.all(8),
              height: 400,
              color: Colors.teal[100],
              /*
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5), BlendMode.dstATop),
                    image: NetworkImage(recipes[i]["imageUrl"]),
                    fit: BoxFit.cover),
              ),*/
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        favouriteFoods[i].name,
                        style: TextStyle(color: Colors.black),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              //color: Colors.red,
                            ),
                            onPressed: () {
                              print("deleted");
                              removeFav(favouriteFoods[i].id, "favouriteFoods");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MyHomePage(title: "Cal Counter")),
                              );
                            },
                            iconSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 45,
                  ),
                  Text(
                    'Calories: ${(favouriteFoods[i].calories).toString()}g',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.arrow_right,
                        size: 15,
                        color: Colors.red,
                      ),
                      Text(
                        '${(favouriteFoods[i].protein).toString()}g',
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                      Spacer(),
                      const Icon(
                        Icons.arrow_right,
                        size: 15,
                        color: Colors.blue,
                      ),
                      Text('${(favouriteFoods[i].fat).toString()}g',
                          style: TextStyle(fontSize: 10, color: Colors.black)),
                      Spacer(),
                      const Icon(
                        Icons.arrow_right,
                        size: 15,
                        color: Colors.yellow,
                      ),
                      Text('${(favouriteFoods[i].carb).toString()}g',
                          style: TextStyle(fontSize: 10, color: Colors.black))
                    ],
                  )
                ],
              )),
          onTap: () {
            print("tis tapped");
          },
        ));
      }
      return items;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Favourites", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
          child: SizedBox(
        height: 800,
        child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: getGrid()),
      )),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyHomePage(title: "Cal Counter")),
                );
              },
            ),
            ListTile(
              textColor: Colors.white,
              title: const Text('Favourites'),
              onTap: () {
                Navigator.pop(context);
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
    );
  }
}
