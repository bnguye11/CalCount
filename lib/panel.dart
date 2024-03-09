import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:calcount/favourites.dart';
import 'package:calcount/food_model.dart';
import 'dart:math';

final foodName = TextEditingController(text: 'food');
final calories = TextEditingController(text: '0');

//macros
final carbs = TextEditingController(text: '0');
final protein = TextEditingController(text: '0');
final fats = TextEditingController(text: '0');

bool favouritedToggle = false;

List<Food> beans = [];
Food selectedFood =
    Food(id: -1, name: "Temp", calories: 0, fat: 0, protein: 0, carb: 0);

void clearTextFields() {
  foodName.text = 'food';
  calories.text = '0';
  carbs.text = '0';
  protein.text = '0';
  fats.text = '0';
}

bool isNum(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

bool checkValidInput() {
  bool valid = false;
  if (isNum(calories.text) &&
      isNum(carbs.text) &&
      isNum(protein.text) &&
      isNum(fats.text)) {
    valid = true;
  }
  return valid;
}

class Panel extends StatefulWidget {
  Panel(
      {Key? key,
      required this.controller,
      required this.panelController,
      required this.callback,
      required this.saveFavourite,
      required this.removeLatest,
      required this.favouriteList})
      : super(key: key);

  final ScrollController controller;
  final PanelController panelController;
  final Function callback;
  final Function saveFavourite;
  final Function removeLatest;
  final Function favouriteList;

  @override
  State<Panel> createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  void setFavouriteList() async {
    var temp = await widget.favouriteList();
    //print("HIIII");
    setState(() {
      beans = temp;
      selectedFood = beans[0];
    });
  }

  @override
  initState() {
    super.initState();
    setFavouriteList();
  }

  @override
  Widget build(BuildContext context) {
    setFavouriteList();
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      controller: widget.controller,
      children: <Widget>[
        const SizedBox(height: 25),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.camera_alt),
              tooltip: 'Scan Nutritional Value',
              onPressed: () {
                print('Volume button clicked');
              },
            ),
            DropdownButton<Food>(
              value: selectedFood,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              style: TextStyle(color: Colors.purple[700]),
              underline: Container(
                height: 2,
                color: Colors.purple[700],
              ),
              onChanged: (Food? newFood) {
                print("clicked");
                print(newFood?.id);
                foodName.text = newFood!.name;
                calories.text = (newFood.calories).toString();
                fats.text = (newFood.fat).toString();
                carbs.text = (newFood.carb).toString();
                protein.text = (newFood.protein).toString();
              },
              items: beans.map((Food map) {
                return DropdownMenuItem<Food>(
                    value: map, child: Text(map.name));
              }).toList(),
            ),
            const Expanded(
              child: Text(''),
            ),
            IconButton(
              //favouritedToggle ? Icons.favorite_outline : Icons.favorite
              icon: Icon(
                  favouritedToggle ? Icons.favorite : Icons.favorite_outline),
              tooltip: 'Favourite Item',
              onPressed: () {
                if (checkValidInput()) {
                  setState(() {
                    favouritedToggle = !favouritedToggle;
                  });

                  if (favouritedToggle) {
                    Food tempFavFood = Food(
                        name: foodName.text,
                        calories: int.parse(calories.text),
                        protein: int.parse(protein.text),
                        fat: int.parse(fats.text),
                        carb: int.parse(carbs.text));

                    widget.saveFavourite(tempFavFood);
                    print("Tis favourited");
                  } else {
                    print("unfavourited");
                    widget.removeLatest();
                  }
                } else{
                  print("womp womp not valid cant favourite");
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Close Panel',
              onPressed: () {
                widget.panelController.close();
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: foodName,
            decoration: const InputDecoration(helperText: 'Food Name'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: calories,
            decoration: const InputDecoration(helperText: 'Calories'),
          ),
        ),
        const Center(
          child: Text("Macro Calories(measured in grams)"),
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: protein,
                decoration: const InputDecoration(helperText: "Est. Protein"),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: TextField(
                controller: fats,
                decoration: const InputDecoration(helperText: "Est. Fats"),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: TextField(
                controller: carbs,
                decoration: const InputDecoration(helperText: "Est. Carbs"),
              ),
            ),
          ],
        ),
        Column(children: [
          const SizedBox(height: 150),
          FloatingActionButton(
            heroTag: "btn2",
            // When the user presses the button, show an alert dialog containing
            // the text that the user has entered into the text field.
            onPressed: () {
              //print(foodName.text);
              //print(calories.text);
              //print(fats.text);
              //print(carbs.text);
              //print(protein.text);
              if (checkValidInput()) {
                Food tempFood = Food(
                    name: foodName.text,
                    calories: int.parse(calories.text),
                    protein: int.parse(protein.text),
                    fat: int.parse(fats.text),
                    carb: int.parse(carbs.text));
                //print(rand);
                widget.callback(tempFood);
                if (favouritedToggle) {
                  setState(() {
                    favouritedToggle = !favouritedToggle;
                  });
                }
                clearTextFields();
                widget.panelController.close();
              } else {
                print("womp womp not valid");
              }
            },
            tooltip: 'Show me the value!',
            child: const Icon(Icons.plus_one),
          ),
        ]),
      ],
    );
  }
}
