// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:calcount/panel.dart';
import 'package:flutter/material.dart';

import 'package:calcount/main.dart';
import 'package:calcount/favourites.dart';
import 'package:calcount/profile.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';


final profileName = TextEditingController();
final profileAge = TextEditingController();
final profileGender = TextEditingController();
final profileWeight = TextEditingController();
final profileHeight = TextEditingController();
final profileCalories = TextEditingController();
final profileProteins = TextEditingController();
final profileFats = TextEditingController();
final profileCarbs = TextEditingController();

var tempName = "";
var tempAge = "";
var tempGender = "";
var tempWeight = "";
var tempHeight = "";
var tempCalories = "";
var tempProteins = "";
var tempFats = "";
var tempCarbs = "";

bool lockEdit = true;

bool isNum(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

bool checkValidProfile() {
  bool isValid = false;
  if (isNum(profileAge.text) && isNum(profileWeight.text) && isNum(profileHeight.text) && 
    isNum(profileCalories.text) && isNum(profileProteins.text) && isNum(profileFats.text) && isNum(profileCarbs.text)){
    isValid = true;
  }
  return isValid;
}

class Settings extends StatefulWidget{
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings>{
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
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(60),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0,10,0,10),
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(100),
                      child: Image(image: AssetImage('assets/images/profile.png')),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 40,
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  color: Color.fromARGB(255, 217, 217, 217),
                  child: Row(
                    children: [
                      Text("Name: ", style: TextStyle(fontSize: 20),),
                      Flexible(
                        child: TextField(
                          readOnly: lockEdit,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.name,
                          controller: profileName,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(0,10,0,10),
                            suffixIcon: IconButton(
                              onPressed: profileName.clear, 
                              icon: lockEdit ? Icon(null) : Icon(Icons.clear),
                            ),
                            hintText: 'Name',
                            hintStyle: const TextStyle(color: Colors.grey, )
                          ),
                        ),
                      ),
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
                      Flexible(
                        child: TextField(
                          readOnly: lockEdit,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          controller: profileAge,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(0,10,0,10),
                            suffixIcon: IconButton(
                              onPressed: profileAge.clear, 
                              icon: lockEdit ? Icon(null) : Icon(Icons.clear),
                            ),
                            hintText: '0',
                            hintStyle: const TextStyle(color: Colors.grey, )
                          ),
                        ),
                      ),
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
                      Flexible(
                        child: TextField(
                          readOnly: lockEdit,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.name,
                          controller: profileGender,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(0,10,0,10),
                            suffixIcon: IconButton(
                              onPressed: profileGender.clear, 
                              icon: lockEdit ? Icon(null) : Icon(Icons.clear),
                            ),
                            hintText: 'Gender',
                            hintStyle: const TextStyle(color: Colors.grey, )
                          ),
                        ),
                      ),
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
                      Flexible(
                        child: TextField(
                          readOnly: lockEdit,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          controller: profileWeight,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(0,10,0,10),
                            suffixIcon: IconButton(
                              onPressed: profileWeight.clear, 
                              icon: lockEdit ? Icon(null) : Icon(Icons.clear),
                            ),
                            hintText: '0',
                            hintStyle: const TextStyle(color: Colors.grey, )
                          ),
                        ),
                      ),
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
                      Flexible(
                        child: TextField(
                          readOnly: lockEdit,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          controller: profileHeight,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(0,10,0,10),
                            suffixIcon: IconButton(
                              onPressed: profileHeight.clear, 
                              icon: lockEdit ? Icon(null) : Icon(Icons.clear),
                            ),
                            hintText: '0',
                            hintStyle: const TextStyle(color: Colors.grey, )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 40,
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  color: Color.fromARGB(255, 217, 217, 217),
                  child: Row(
                    children: [
                      Text("Set Goals: ", style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  color: Color.fromARGB(255, 217, 217, 217),
                  child: Row(
                    children: [
                      Text("Calories: ", style: TextStyle(fontSize: 20),),
                      Flexible(
                        child: TextField(
                          readOnly: lockEdit,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          controller: profileCalories,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(0,10,0,10),
                            suffixIcon: IconButton(
                              onPressed: profileCalories.clear, 
                              icon: lockEdit ? Icon(null) : Icon(Icons.clear),
                            ),
                            hintText: '0',
                            hintStyle: const TextStyle(color: Colors.grey, )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  color: Color.fromARGB(255, 217, 217, 217),
                  child: Row(
                    children: [
                      Text("Proteins: ", style: TextStyle(fontSize: 20),),
                      Flexible(
                        child: TextField(
                          readOnly: lockEdit,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          controller: profileProteins,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(0,10,0,10),
                            suffixIcon: IconButton(
                              onPressed: profileProteins.clear, 
                              icon: lockEdit ? Icon(null) : Icon(Icons.clear),
                            ),
                            hintText: '0',
                            hintStyle: const TextStyle(color: Colors.grey, )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  color: Color.fromARGB(255, 217, 217, 217),
                  child: Row(
                    children: [
                      Text("Fats: ", style: TextStyle(fontSize: 20),),
                      Flexible(
                        child: TextField(
                          readOnly: lockEdit,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          controller: profileFats,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(0,10,0,10),
                            suffixIcon: IconButton(
                              onPressed: profileFats.clear, 
                              icon: lockEdit ? Icon(null) : Icon(Icons.clear),
                            ),
                            hintText: '0',
                            hintStyle: const TextStyle(color: Colors.grey, )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  color: Color.fromARGB(255, 217, 217, 217),
                  child: Row(
                    children: [
                      Text("Carbs: ", style: TextStyle(fontSize: 20),),
                      Flexible(
                        child: TextField(
                          readOnly: lockEdit,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          controller: profileCarbs,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(0,10,0,10),
                            suffixIcon: IconButton(
                              onPressed: profileCarbs.clear, 
                              icon: lockEdit ? Icon(null) : Icon(Icons.clear),
                            ),
                            hintText: '0',
                            hintStyle: const TextStyle(color: Colors.grey, )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        if(lockEdit){
                          tempName = profileName.text;
                          tempAge = profileAge.text;
                          tempGender = profileGender.text;
                          tempWeight = profileWeight.text;
                          tempHeight = profileHeight.text;
                          tempCalories = profileCalories.text;
                          tempProteins = profileProteins.text;
                          tempFats = profileFats.text;
                          tempCarbs = profileCarbs.text;
                        } else {
                          profileName.text = tempName;
                          profileAge.text = tempAge;
                          profileGender.text = tempGender;
                          profileWeight.text = tempWeight;
                          profileHeight.text = tempHeight;
                          profileCalories.text = tempCalories;
                          profileProteins.text = tempProteins;
                          profileFats.text = tempFats;
                          profileCarbs.text = tempCarbs;
                        }
                        setState(() {
                          lockEdit = !lockEdit;
                        });
                      }, 
                      child: lockEdit ? Text("Edit") : Text("Cancel"),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: (){
                        if(checkValidProfile()){
                          Profile tempProfile = Profile(
                            id: 1,
                            name: profileName.text,
                            age: int.parse(profileAge.text),
                            gender: profileGender.text,
                            weight: double.parse(profileWeight.text),
                            height: double.parse(profileHeight.text),
                            calories: double.parse(profileCalories.text),
                            protein: double.parse(profileProteins.text),
                            fat: double.parse(profileFats.text),
                            carb: double.parse(profileCarbs.text),
                          );
                        }
                        setState(() {
                          lockEdit = true;
                        });
                      }, 
                      child: Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
  
  
}