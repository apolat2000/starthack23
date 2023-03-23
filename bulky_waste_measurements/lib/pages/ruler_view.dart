import 'package:flutter/material.dart';
import 'package:rulers/rulers.dart';

class RulerPage extends StatefulWidget {
  const RulerPage({super.key});

  @override
  State<RulerPage> createState() => RulerPageState();
}

class RulerPageState extends State<RulerPage> {
  bool measuringEnabled = false;

  double distance = 0;

  @override
  void initState() {
    super.initState();
  }

  double cm = 10;

  @override
  Widget build(BuildContext context) {
    return RulerWidget(
      scaleBackgroundColor: Colors.grey.shade100,
      height: 100,
      indicatorWidget: Column(
        children: <Widget>[
          Icon(
            Icons.arrow_drop_down,
            color: Colors.red,
          ),
        ],
      ),
      largeScaleBarsInterval: 300,
      smallScaleBarsInterval: 9,
      lowerIndicatorLimit: 0,
      lowerMidIndicatorLimit: cm,
      upperMidIndicatorLimit: cm,
      upperIndicatorLimit: 0,
      barsColor: Colors.grey,
      inRangeBarColor: Colors.green,
      behindRangeBarColor: Colors.orangeAccent,
      outRangeBarColor: Colors.red,
      axis: Axis.vertical,
    );
  }

  screen_height_in_cm() {
    return MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
  }
}
