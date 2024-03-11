// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:calcount/main.dart';
import 'package:calcount/favourites.dart';
import 'package:flutter/widgets.dart';

class Settings extends StatelessWidget{
  const Settings({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage(title: "Cal Counter")),
                  );
                },
              ),
              ListTile(
                textColor: Colors.white,
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
                textColor: Colors.white,
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        )
      ),
      body: Center(
        child: 
        Container(
          padding: EdgeInsets.all(60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(100),
                    child: Image(image: AssetImage('assets/images/profile.png')),
                  ),
                ),
              ),
              Container(
                height: 40,
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                color: Color.fromARGB(255, 217, 217, 217),
                child: Row(
                  children: [
                    Text("Name: ", style: TextStyle(fontSize: 20),),
                    Text("Temperous", style: TextStyle(fontSize: 20),),
                  ],
                ),
              ),
              Container(
                height: 40,
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                color: Color.fromARGB(255, 217, 217, 217),
                child: Row(
                  children: [
                    Text("Age: ", style: TextStyle(fontSize: 20),),
                    Text("32", style: TextStyle(fontSize: 20),),
                  ],
                ),
              ),
              Container(
                height: 40,
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                color: Color.fromARGB(255, 217, 217, 217),
                child: Row(
                  children: [
                    Text("Gender: ", style: TextStyle(fontSize: 20),),
                    Text("Male", style: TextStyle(fontSize: 20),),
                  ],
                ),
              ),
              Container(
                height: 40,
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                color: Color.fromARGB(255, 217, 217, 217),
                child: Row(
                  children: [
                    Text("Weight: ", style: TextStyle(fontSize: 20),),
                    Text("50 kg", style: TextStyle(fontSize: 20),),
                  ],
                ),
              ),
              Container(
                height: 40,
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                color: Color.fromARGB(255, 217, 217, 217),
                child: Row(
                  children: [
                    Text("Height: ", style: TextStyle(fontSize: 20),),
                    Text("170 cm", style: TextStyle(fontSize: 20),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}