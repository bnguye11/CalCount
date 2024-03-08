import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:calcount/favourites.dart';
import 'package:calcount/food_model.dart';
import 'dart:math';

final foodName = TextEditingController();
final calories = TextEditingController();

//macros
final carbs = TextEditingController();
final protein = TextEditingController();
final fats = TextEditingController();

bool favouritedToggle = false;

void clearTextFields() {
  foodName.clear();
  calories.clear();
  carbs.clear();
  protein.clear();
  fats.clear();
}

class Panel extends StatefulWidget {
  const Panel(
      {Key? key,
      required this.controller,
      required this.panelController,
      required this.callback,
      required this.saveFavourite,
      required this.removeLatest})
      : super(key: key);

  final ScrollController controller;
  final PanelController panelController;
  final Function callback;
  final Function saveFavourite;
  final Function removeLatest;

  @override
  State<Panel> createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  @override
  Widget build(BuildContext context) {
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
            IconButton(
              icon: const Icon(Icons.import_contacts),
              tooltip: 'Import Favourite Item',
              onPressed: () {
                //removing for now
                /*
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Favourites()),
                );*/
              },
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
            },
            tooltip: 'Show me the value!',
            child: const Icon(Icons.plus_one),
          ),
        ]),
      ],
    );
  }
}
