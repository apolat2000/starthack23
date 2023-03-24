import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class DeadReckoning {
  int lastTimestamp = 0;
  int currentTimestamp = 0;

  ValueNotifier<double> distance = ValueNotifier(0.0);
  ValueNotifier<double> acceleration = ValueNotifier(0.0);
  ValueNotifier<double> speed = ValueNotifier(0.0);

  static const double threshold = 0.2;
  static const int timerInterval = 50;

  Timer? timer;

  DeadReckoning() {}

  void calculateSpeed(double acceleration) {
    double diffTime = timerInterval / 1000;

    // Calculate speed
    speed.value += acceleration * diffTime;
  }

  void calculateDistance(double speed) {
    double diffTime = timerInterval / 1000;
    // Calculate distance
    distance.value += speed * diffTime;
  }

  void accelerometerListener(UserAccelerometerEvent event) {
    acceleration.value = event.y;
    // Threshold protection
    if (acceleration.value.abs() < threshold) {
      acceleration.value = 0;
      return;
    }
  }

  void calculate(Timer timer) {
    print("1");
    calculateSpeed(acceleration.value);

    // Threshold protection
    if (speed.value < 0) {
      speed.value = 0;
    }

    calculateDistance(speed.value);
  }

  void start() {
    userAccelerometerEvents.listen(accelerometerListener);

    // Invoke the function calculate() every 10ms
    timer =
        Timer.periodic(const Duration(milliseconds: timerInterval), calculate);
  }

  void resetMeasurement() {
    distance.value = 0;
    speed.value = 0;
  }
}
