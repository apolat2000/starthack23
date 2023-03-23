import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class DeadReckoning {
  double x = 0;
  double y = 0;
  double z = 0;

  double y_mistake = 0;

  int lastTimestamp = 0;

  double distance = 0;

  static const double threshold = 0.00;

  DeadReckoning() {}

  // Calibration

  int calibrationCount = 0;
  int maxCalibrationCount = 10000;
  double calibrationSum = 0;

  void calibrate() {
    calibrationCount = 0;
    calibrationSum = 0;
  }

  void calculateCalibration(double y) {
    if (calibrationCount < maxCalibrationCount) {
      calibrationCount++;
      calibrationSum += y;
    } else {
      y_mistake = calibrationSum / maxCalibrationCount;
    }
  }

  void accelerometerListener(UserAccelerometerEvent event) {
    calculateCalibration(event.y);

    if (event.y > threshold) {
      double y_unrounded = event.y - y_mistake;

      // Round to 2 decimal places
      y = (y_unrounded * 100).round() / 100;
    } else {
      y = 0;
    }

    _updateDistance();

    //  Round to 2 decimal places and print everything
    print(
        "y: ${y}, event.y: ${y.toStringAsFixed(2)} distance: ${distance.toStringAsFixed(2)}");
  }

  void start() {
    userAccelerometerEvents.listen(accelerometerListener);
  }

  void resetMeasurement() {
    distance = 0;
  }

  // Measure only by y-axis
  void _updateDistance() {
    if (lastTimestamp == 0) {
      lastTimestamp = DateTime.now().microsecondsSinceEpoch;
      return;
    }

    int currentTimestamp = DateTime.now().microsecondsSinceEpoch;

    //  Calculate time difference in seconds
    double timeDiff = (currentTimestamp - lastTimestamp) / 1000000;

    distance += y * timeDiff;

    // Set last timestamp to current timestamp
    lastTimestamp = currentTimestamp;
  }
}
