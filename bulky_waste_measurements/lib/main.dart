import 'package:bulky_waste_measurements/pages/camera_view.dart';
import 'package:bulky_waste_measurements/pages/ruler_view.dart';
import 'package:bulky_waste_measurements/utils/dead_reckoning.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Set the orientation to portrait
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const RulerPage(),
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
  bool measuringEnabled = false;

  double distance = 0;

  DeadReckoning deadReckoning = DeadReckoning();

  void toggleMeasuring() {
    setState(() => measuringEnabled = !measuringEnabled);
    if (measuringEnabled) {
      distance = 0;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print("INITIALIZING");
    super.initState();

    deadReckoning.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            // Blue button
            ElevatedButton(
                onPressed: deadReckoning.resetMeasurement,
                child: Text("Reset")),
            // Blue button
            ElevatedButton(
                onPressed: toggleMeasuring,
                child: Text(measuringEnabled ? "Stop" : "Start")),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
