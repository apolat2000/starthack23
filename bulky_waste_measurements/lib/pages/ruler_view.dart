import 'package:bulky_waste_measurements/utils/dead_reckoning.dart';
import 'package:flutter/material.dart';
import 'package:rulers/rulers.dart';
import 'dart:math';

class RulerPage extends StatefulWidget {
  const RulerPage({super.key});

  @override
  State<RulerPage> createState() => RulerPageState();
}

class RulerPageState extends State<RulerPage> {
  double width = 0;
  double height = 0;
  double length = 0;
  int step = 0;

  bool stepMeasuringStarted = false;

  bool measuringEnabled = false;

  double distance = 0;

  int distanceValue = 0;

  late ScrollController scrollController;

  DeadReckoning deadReckoning = DeadReckoning();
  bool isMeasuring = false;

  void setHeight(double height) {
    setState(() {
      distance = height;
    });
  }

  void startMeasuring() {
    isMeasuring = true;
    deadReckoning.resetMeasurement();
    setState(() {
      distance = 0;
    });
  }

  void stopMeasuring() {
    isMeasuring = false;
    if (step == 0) {
      setState(() {
        step++;
        width = deadReckoning.distance.value;
        deadReckoning.resetMeasurement();
        // round to first decimal
        width = (width * 10).roundToDouble() / 10;
      });

      return;
    } else if (step == 1) {
      setState(() {
        step++;
        length = deadReckoning.distance.value;
        deadReckoning.resetMeasurement();
        // round to first decimal
        length = (width * 10).roundToDouble() / 10;
      });
      return;
    } else if (step == 2) {
      setState(() {
        step++;
        height = deadReckoning.distance.value;
        deadReckoning.resetMeasurement();
        // round to first decimal
        height = (width * 10).roundToDouble() / 10;
      });
      return;
    }
  }

  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 35);
    NeverScrollableScrollPhysics();
    super.initState();
    deadReckoning.start();
    deadReckoning.distance.addListener(() {
      double inCm = deadReckoning.distance.value * 100;
      double inM = inCm * 39 + 35;
      if (isMeasuring) {
        //distance = inCm.roundToDouble();
        scrollController.jumpTo(inM);
      }
    });

    // cm has to be set to the amount of pixels in 1 cm

    // ScrollCOntroller set to 2*cm
    //scrollController.jumpTo(200);
  }

  double cm = 10;

  @override
  Widget build(BuildContext context) {
    var half_size = (screen_height_in_cm() / 2).round();
    cm = 1 / MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
        body: Container(
            child: Stack(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: RulerWidget(
            physics: NeverScrollableScrollPhysics(),
            initial_offset:
                (half_size / MediaQuery.of(context).devicePixelRatio) *
                        (1 / 4) -
                    MediaQuery.of(context).padding.top,
            scaleBackgroundColor: Colors.grey.shade100,
            height: MediaQuery.of(context).size.width * .2,
            indicatorWidget: Column(
              children: <Widget>[
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.red,
                ),
              ],
            ),
            smallScaleBarsInterval: 5,
            upper_limit: 300,
            lower_limit: 0,
            barsColor: Colors.grey,
            axis: Axis.vertical,
            scrollController: scrollController,
          )),
      Positioned(
          left: 0,
          bottom:
              (half_size / MediaQuery.of(context).devicePixelRatio) * (1 / 4) -
                  15,
          child: Container(
              color: Colors.red,
              width: MediaQuery.of(context).size.width * .25,
              height: 5)),
      /*Positioned(
          left: MediaQuery.of(context).size.width * .28,
          bottom:
              (half_size / MediaQuery.of(context).devicePixelRatio) * (1 / 4) -
                  12.5 -
                  15,
          child: ValueListenableBuilder(
              valueListenable: deadReckoning.distance,
              builder: (context, value, child) {
                if (isMeasuring) {
                  distanceValue = (value * 100).round();
                }

                return Text('$distanceValue cm',
                    style: const TextStyle(
                        color: Colors.black87, fontSize: 25, height: 1));
              })),*/
      Positioned(
        top: (half_size / MediaQuery.of(context).devicePixelRatio) * (1 / 4) -
            12.5,
        left: MediaQuery.of(context).size.width * .28,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: MediaQuery.of(context).size.width * 0.72,
            height: MediaQuery.of(context).size.height * .8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                step > 2
                    ? Wrap(
                        children: [
                          Column(
                            children: [
                              Text("The size of the object is: "),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "$width x $length x $height m",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Text("Collection of bulky waste will cost: "),
                              SizedBox(
                                height: 10,
                              ),
                              // TODO: calculate price
                              Text(
                                  (width * height * length * 5 + 5)
                                          .toStringAsFixed(2) +
                                      " CHF",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),

                              SizedBox(
                                height: 50,
                              ),
                              Text("The collection appointment: "),
                              SizedBox(
                                height: 10,
                              ),
                              // TODO: calculate price
                              Text("25.03.2023, 10:00-12:00",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.green)),
                                  onPressed: (() => null),
                                  child: Text('Pay and get a QR-certificate'),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    : Wrap(
                        children: [
                          Column(
                            children: [
                              Text(
                                "Step 1: Measure width",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    decoration: step == 0
                                        ? TextDecoration.underline
                                        : TextDecoration.none),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ValueListenableBuilder(
                                  valueListenable: deadReckoning.distance,
                                  builder: (context, value, child) {
                                    return Text("Width is  " +
                                        (step > 0
                                            ? width.toString()
                                            : (!isMeasuring
                                                ? '???'
                                                : value.toStringAsFixed(2))) +
                                        " m");
                                  }),
                              SizedBox(
                                height: 40,
                              ),

                              // LENGTH
                              Text(
                                "Step 2: Measure length",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    decoration: step == 1
                                        ? TextDecoration.underline
                                        : TextDecoration.none),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ValueListenableBuilder(
                                  valueListenable: deadReckoning.distance,
                                  builder: (context, value, child) {
                                    return Text(step < 1
                                        ? "..."
                                        : "Length is  " +
                                            (step > 1
                                                ? length.toString()
                                                : (!isMeasuring
                                                    ? '???'
                                                    : value
                                                        .toStringAsFixed(2))) +
                                            " m");
                                  }),
                              SizedBox(
                                height: 40,
                              ),

                              // HEIGHT

                              Text(
                                "Step 3: Measure height",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    decoration: step == 2
                                        ? TextDecoration.underline
                                        : TextDecoration.none),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ValueListenableBuilder(
                                  valueListenable: deadReckoning.distance,
                                  builder: (context, value, child) {
                                    return Text(step < 2
                                        ? "..."
                                        : "Height is  " +
                                            (step > 2
                                                ? length.toString()
                                                : (!isMeasuring
                                                    ? '???'
                                                    : value
                                                        .toStringAsFixed(2))) +
                                            " m");
                                  }),
                              SizedBox(
                                height: 40,
                              ),
                              Container(
                                  width: double.infinity,
                                  child: GestureDetector(
                                    onTapDown: (details) {
                                      startMeasuring();
                                    },
                                    onTapCancel: () => stopMeasuring(),
                                    onTapUp: (details) {
                                      print("tap up");
                                    },
                                    child: ElevatedButton(
                                        onPressed: (() => null),
                                        child: Text('Hold to measure')),
                                  ))
                            ],
                          ),
                        ],
                      ),
              ],
            )),
      ),
    ])));
  }

  screen_height_in_cm() {
    return MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
  }
}

//customised from package rulers

class RulerWidget extends StatefulWidget {
  /// upper score
  int upper_limit;

  ///
  int lower_limit;

  /// number of small bars b/w two [largeScaleBarsInterval] on scale
  int smallScaleBarsInterval;

  /// starting number on scale to show marker [indicatorWidget]
  int lowerIndicatorLimit;

  /// ending number on scale  to show marker [indicatorWidget]
  final int upperIndicatorLimit;

  /// mid starting number on scale
  int lowerMidIndicatorLimit;

  /// mid ending number on scale
  int upperMidIndicatorLimit;

  /// color of bars on scale [largeScaleBarsInterval] and [smallScaleBarsInterval]
  final Color barsColor;

  /// color between [lowerMidIndicatorLimit] and [upperMidIndicatorLimit] bars of scale
  final Color inRangeBarColor;

  /// color between [upperMidIndicatorLimit] and [upperIndicatorLimit] bars of scale (Optional)
  final Color outRangeBarColor;

  /// color between [lowerMidIndicatorLimit] and [lowerIndicatorLimit] bars of scale (Optional)
  final Color behindRangeBarColor;

  /// color of scale
  Color scaleBackgroundColor;

  /// Custom Indicator over bars on scale
  Widget indicatorWidget = Container();

  /// height of scale if horizontal or width of scale if vertical
  final double height;

  /// Scale to be horizontal or vertical ,by default horizontal
  final Axis axis;

  final ScrollController? scrollController;

  ScrollPhysics? physics;

  double? initial_offset;

  RulerWidget(
      {Key? key,
      required this.height,
      required this.smallScaleBarsInterval,
      required this.scaleBackgroundColor,
      required this.barsColor,
      this.upper_limit = 10,
      this.lower_limit = 5,
      this.indicatorWidget = const SizedBox(),
      this.lowerIndicatorLimit = 0,
      this.lowerMidIndicatorLimit = 0,
      this.upperMidIndicatorLimit = 0,
      this.upperIndicatorLimit = 0,
      this.physics,
      this.initial_offset,
      this.inRangeBarColor = Colors.black,
      this.behindRangeBarColor = Colors.black,
      this.outRangeBarColor = Colors.black,
      this.scrollController,
      this.axis = Axis.horizontal})
      : super(key: key);

  @override
  _RulerWidgetState createState() => _RulerWidgetState();
}

class _RulerWidgetState extends State<RulerWidget> {
  late List<Widget> scaleWidgetList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('widget, lower limit ${widget.lower_limit}');
    return Container(
      color: widget.scaleBackgroundColor,
      height: widget.axis == Axis.horizontal ? widget.height : null,
      width: widget.axis == Axis.vertical ? widget.height : null,
      child: ListView.builder(
          itemCount: widget.upper_limit - widget.lower_limit,
          physics: widget.physics,
          reverse: true,
          itemBuilder: (context, index) {
            var i = index;
            if (widget.initial_offset != null) {
              i -= 1;
              if (index == 0) {
                return Container(height: widget.initial_offset);
              }
            }

            //+ widget.lower_limit;
            return RotatedBox(
                quarterTurns: widget.axis == Axis.horizontal ? 4 : 3,
                child: RulerBarWidget(
                  key: ValueKey(i),
                  num: i,
                  type: RulerBar.BIG_BAR,
                  lowerLimit: widget.lowerIndicatorLimit,
                  upperLimit: widget.upperIndicatorLimit,
                  indicatorWidget: widget.indicatorWidget,
                  midLimitLower: widget.lowerMidIndicatorLimit,
                  midLimitUpper: widget.upperMidIndicatorLimit,
                  midInterval: widget.smallScaleBarsInterval,
                  normalBarColor: widget.barsColor,
                  inRangeBarColor: widget.inRangeBarColor,
                  behindRangeBarColor: widget.behindRangeBarColor,
                  outRangeBarColor: widget.outRangeBarColor,
                  axis: widget.axis,
                ));
          },
          controller: widget.scrollController,
          scrollDirection: widget.axis),
    );
  }
}

class RulerBarWidget extends StatelessWidget {
  final RulerBar type;

  int num;

  int midInterval;
  int lowerLimit;
  int upperLimit;
  int midLimitLower;
  int midLimitUpper;
  Color normalBarColor;
  Color inRangeBarColor;
  Color outRangeBarColor;
  Color behindRangeBarColor;
  Widget indicatorWidget;
  Axis axis;

  RulerBarWidget(
      {Key? key,
      required this.num,
      required this.type,
      required this.indicatorWidget,
      required this.lowerLimit,
      required this.midLimitLower,
      required this.midLimitUpper,
      required this.upperLimit,
      required this.midInterval,
      required this.normalBarColor,
      required this.inRangeBarColor,
      required this.behindRangeBarColor,
      required this.outRangeBarColor,
      required this.axis})
      : super(key: key);

  final double _spacing = 5.0;
  List<Widget> _children = List.empty(growable: true);
  bool _show = false;

  @override
  Widget build(BuildContext context) {
    if (_children.isEmpty) _getSmallBars();

    return Container(
        width: 38, //38 logical pixel == one centimeter
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _children,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Transform.rotate(
                  angle: pi / 2,
                  child: Container(
                      child: Text(
                    num.toString(),
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ))),
            ),
          ],
        ));
  }

  /// get color of small bar according to range
  Color _getSmallBarColor() {
    if (_getScalePosition(num) >= _getScalePosition(lowerLimit) &&
        _getScalePosition(num) < _getScalePosition(midLimitLower))
      return behindRangeBarColor;
    else if (_getScalePosition(num) >= _getScalePosition(midLimitLower) &&
        _getScalePosition(num) < _getScalePosition(midLimitUpper))
      return inRangeBarColor;
    else if (_getScalePosition(num) > _getScalePosition(midLimitUpper) &&
        _getScalePosition(num) < _getScalePosition(upperLimit))
      return outRangeBarColor;
    else if (_getScalePosition(num) == _getScalePosition(midLimitUpper) &&
        _getScalePosition(num) < _getScalePosition(upperLimit))
      return outRangeBarColor;
    else if (_getScalePosition(num) == _getScalePosition(midLimitUpper) &&
        _getScalePosition(num) == _getScalePosition(upperLimit))
      return normalBarColor;
    else
      return normalBarColor;
  }

  /// get color of bigger bar according to range
  Color _getBigBarColor() {
    if (_getScalePosition(num) >= _getScalePosition(lowerLimit) &&
        _getScalePosition(num) < _getScalePosition(midLimitLower))
      return normalBarColor;
    else if (_getScalePosition(num) >= _getScalePosition(midLimitLower) &&
        _getScalePosition(num) <= _getScalePosition(midLimitUpper))
      return inRangeBarColor;
    else if (_getScalePosition(num) > _getScalePosition(midLimitUpper) &&
        _getScalePosition(num) <= _getScalePosition(upperLimit))
      return outRangeBarColor;
    else
      return normalBarColor;
  }

  void _getSmallBars() {
    _children = List.empty(growable: true);

    _children.add(
      Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              color: _getBigBarColor(),
              width: 2,
              height: 20,
            ),
          ),
        ],
      ),
    );

    for (int i = 1; i <= 9; i++) {
      _children.add(
        Container(
            color: _getSmallBarColor(),
            width: 0.5,
            height: 10,
            margin: EdgeInsets.only(top: 20, left: 1, right: 1)),
      );
    }
  }

  _getScalePosition(int num) {
    return num + (num - 1) * 3;
  }
}

enum RulerBar { BIG_BAR, SMALL_BAR }
