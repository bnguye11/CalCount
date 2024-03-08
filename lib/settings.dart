import 'package:flutter/material.dart';

import 'package:calcount/main.dart';
import 'package:calcount/favourites.dart';

class Settings extends StatelessWidget{
  const Settings({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Profile"),
      ),
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
                  MaterialPageRoute(builder: (context) => const MyHomePage(title: "Cal Counter")),
                );
              },
            ),
            ListTile(
              title: const Text('Favourites'),
              onTap: () {
                //temp remove for now
                /*
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Favourites()),
                );*/
              },
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
        )
      ),
    );
  }
}