import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:calcount/food_model.dart';
import 'dart:math';


final foodName = TextEditingController();
final calories = TextEditingController();
Random random = new Random();
//macros
final carbs = TextEditingController();
final protien = TextEditingController();
final fats = TextEditingController();

class Panel extends StatelessWidget {
  final ScrollController controller;
  final PanelController panelController;
  final Function callback;
  
  const Panel({Key? key, required this.controller, required this.panelController, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //bool favouritedToggle = false;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      controller: controller,
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
                print('Volume button clicked');
              },
            ),
            const Expanded(
              child: Text(''),
            ),
            IconButton(
              icon:  const Icon(Icons.favorite_outline),
              tooltip: 'Favourite Item',
              onPressed: () {
                print('Volume button clicked');
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Close Panel',
              onPressed: () {
                panelController.close();
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
                controller: protien,
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
            // When the user presses the button, show an alert dialog containing
            // the text that the user has entered into the text field.
            onPressed: () {
              //print(foodName.text);
              //print(calories.text);
              //print(fats.text);
              //print(carbs.text);
              //print(protien.text);
              var rand = random.nextInt(100);
              Food tempFood =  Food(id: rand, name: foodName.text, calories: int.parse(calories.text), protein: int.parse(protien.text), fat: int.parse(fats.text), carb: int.parse(carbs.text));
              //print(rand);
              callback(tempFood);
              panelController.close();
            },
            tooltip: 'Show me the value!',
            child: const Icon(Icons.plus_one),
          ),
        ]),
      ],
    );
  }
}
