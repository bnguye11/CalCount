import 'package:flutter/material.dart';

import 'package:calcount/main.dart';
import 'package:calcount/settings.dart';
import 'package:calcount/food_model.dart';

class Favourites extends StatelessWidget {
  final favouriteFoods;

  Favourites({Key? key, required this.favouriteFoods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < favouriteFoods.length; i++) {
      print(favouriteFoods[i].name);
    }

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
                      Container(
                        width: 65,
                      ),
                    ],
                  ),
                  Container(
                    height: 65,
                  ),
                  Text(
                    'Calories: ${(favouriteFoods[i].calories).toString()}g',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.punch_clock,
                        size: 15,
                        color: Colors.white,
                      ),
                      Text(
                        '${(favouriteFoods[i].protein).toString()}g',
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                      Spacer(),
                      const Icon(
                        Icons.shopping_bag,
                        size: 15,
                        color: Colors.white,
                      ),
                      Text('${(favouriteFoods[i].fat).toString()}g',
                          style: TextStyle(fontSize: 10, color: Colors.black)),
                      Spacer(),
                      const Icon(
                        Icons.question_answer,
                        size: 15,
                        color: Colors.white,
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Favourites"),
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
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Cal Counter'),
          ),
          ListTile(
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
            title: const Text('Favourites'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
          ),
        ],
      )),
    );
  }
}
