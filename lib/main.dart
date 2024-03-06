import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:calcount/panel.dart';
import 'package:calcount/food_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cal Counter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cal Counter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;
  final ScrollController controller = ScrollController();
  final PanelController panelController = PanelController();
  Food newlyAddedFood = Food(id: -1, name: "Temp", calories: 0, fat: 0,protein: 0, carb: 0);

  callback(updatedFood) {
    setState(() {
      newlyAddedFood = updatedFood;
    });
  }

  Text setText() {
    Text tempText;
    Food tempFood = newlyAddedFood;
    
    if (tempFood.id == -1) {
      tempText = const Text("no new food added :(");
    } else {
      tempText = Text(tempFood.name);
    }

    return tempText;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.8;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SlidingUpPanel(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              setText(),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              FloatingActionButton(
                onPressed: () {
                  panelController.open();
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
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
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
