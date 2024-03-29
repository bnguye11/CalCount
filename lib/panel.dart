import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:calcount/favourites.dart';
import 'package:calcount/food_model.dart';
import 'dart:math';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:string_similarity/string_similarity.dart';

final foodName = TextEditingController();
final calories = TextEditingController();

//macros
final carbs = TextEditingController();
final protein = TextEditingController();
final fats = TextEditingController();

bool favouritedToggle = false;

List<Food> beans = [];
Food selectedFood =
    Food(id: -1, name: "Temp", calories: 0, fat: 0, protein: 0, carb: 0);

void clearTextFields() {
  foodName.text = '';
  calories.text = '';
  carbs.text = '';
  protein.text = '';
  fats.text = '';
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
  int? _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  bool _autoFocusOcr = true;
  bool _torchOcr = false;
  bool _multipleOcr = false;
  bool _waitTapOcr = false;
  bool _showTextOcr = true;
  Size? _previewOcr;
  List<OcrText> _textsOcr = [];

  void setFavouriteList() async {
    var temp = await widget.favouriteList();
    //print("HIIII");
    setState(() {
      beans = temp;
      selectedFood = beans[0];
    });
  }

  void checkRelevant() {
    
    var tempArr = _textsOcr[0].value.replaceAll(RegExp(r'\n'),'').split(' ');
    var tempValue = "";

    print("Called");
    
    //this probably needs to be simpliifed and maybe made into a switch case
    for (int i = 0; i < tempArr.length; i++) {
      print("checking!");
      print(tempArr[i]);
      //Lets text if its atlest 70% similiar for now
      if ((tempArr[i]).toLowerCase().similarityTo('calories') > 0.70) {
        if ((i + 1) < tempArr.length) {
          tempValue = tempArr[(i + 1)];
          print("HERE IS BEFORE");
          print(tempValue);
          //tempValue.replaceAll(RegExp(r'[Ii/]'), '1');
          
          tempValue = tempValue.replaceAll(new RegExp(r'[^\d\n]+'), '').trim();
          print("HERE IS CALORIES");
          print(tempValue);
          calories.text = tempValue;
        }
      } else if ((tempArr[i]).toLowerCase().similarityTo('protein') > 0.70) {
        if ((i + 1) < tempArr.length) {
          tempValue = tempArr[(i + 1)];
          print("HERE IS BEFORE");
          print(tempValue);
          //tempValue.replaceAll(RegExp(r'[Ii/]'), '1');
          tempValue = tempValue.replaceAll(RegExp(r'[^\d\n]+'), '').trim();
          print("HERE IS protein");
          print(tempValue);
          protein.text = tempValue;
        } // need to account for french make it slightly easer to pass since it seems to pass through the radars alot
      } else if ((tempArr[i]).toLowerCase().similarityTo('fat') > 0.60 ||
          (tempArr[i]).toLowerCase().similarityTo('lipides') > 0.60) {
        if ((i + 1) < tempArr.length) {
          tempValue = tempArr[(i + 1)];
          print("HERE IS BEFORE");
          print(tempValue);
          //tempValue.replaceAll(RegExp(r'[Ii/]'), '1');
          tempValue = tempValue.replaceAll(RegExp(r'[^\d\n]+'), '').trim();
          print("HERE IS fats");
          print(tempValue);
          fats.text = tempValue;
        } // parle on francais
      } else if ((tempArr[i]).toLowerCase().similarityTo('carbohydrate') >
              0.70 ||
          (tempArr[i]).toLowerCase().similarityTo('glucides') > 0.70) {
        if ((i + 1) < tempArr.length) {
          tempValue = tempArr[(i + 1)];
          print("HERE IS BEFORE");
          print(tempValue);
          //tempValue.replaceAll(RegExp(r'[Ii/]'), '1');
          tempValue = tempValue.replaceAll(RegExp(r'[^\d\n]+'), '').trim();
          print("HERE IS carbs");
          print(tempValue);
          carbs.text = tempValue;
        }
      }
    }
  }

  @override
  initState() {
    super.initState();
    setFavouriteList();
    FlutterMobileVision.start().then((previewSizes) => setState(() {
          _previewOcr = previewSizes[_cameraOcr]!.first;
        }));
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
              icon: const Icon(Icons.add_a_photo),
              tooltip: 'Scan Nutritional Value',
              onPressed: () async {
                List<OcrText> texts = [];
                List<String> values = [];
                Size _scanpreviewOcr =
                    _previewOcr ?? FlutterMobileVision.PREVIEW;
                try {
                  texts = await FlutterMobileVision.read(
                    flash: _torchOcr,
                    autoFocus: _autoFocusOcr,
                    multiple: _multipleOcr,
                    //makes it so image is clickable
                    waitTap: true,
                    //OPTIONAL: close camera after tap, even if there are no detection.
                    //Camera would usually stay on, until there is a valid detection
                    forceCloseCameraOnTap: true,
                    //OPTIONAL: path to save image to. leave empty if you do not want to save the image
                    //imagePath: '', //'path/to/file.jpg'
                    showText: _showTextOcr,
                    preview: _previewOcr ?? FlutterMobileVision.PREVIEW,
                    scanArea: Size(_scanpreviewOcr.width - 10,
                        _scanpreviewOcr.height - 10),
                    camera: _cameraOcr ?? FlutterMobileVision.CAMERA_BACK,
                    fps: 2.0,
                  );
                  //texts.forEach((val) {
                  //  values.add(val.value.toString());
                  //});
                  if (!mounted) return;
                  //setState(() => _textsOcr = texts);
                } on Exception {
                  texts.add(OcrText('Failed to recognize text.'));
                }

                if (!mounted) return;

                setState(() => _textsOcr = texts);

                if (_textsOcr[0].value != 'Failed to recognize text.') {
                  checkRelevant();
                }
                print("HERE IS RELEVANT TEXT FOUND");

                print(_textsOcr[0].value);
              },
            ),
            DropdownButton<Food>(
              value: selectedFood,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              style: TextStyle(color: const Color.fromARGB(255, 8, 6, 8)),
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
                } else {
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
            decoration: const InputDecoration(
                helperText: 'Food Name', hintText: 'Food'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: calories,
            decoration:
                const InputDecoration(helperText: 'Calories', hintText: '0'),
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
                decoration: const InputDecoration(
                    helperText: "Est. Protein", hintText: '0'),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: TextField(
                controller: fats,
                decoration: const InputDecoration(
                    helperText: "Est. Fats", hintText: '0'),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: TextField(
                controller: carbs,
                decoration: const InputDecoration(
                    helperText: "Est. Carbs", hintText: '0'),
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
            child: const Icon(Icons.add),
          ),
        ]),
      ],
    );
  }
}
