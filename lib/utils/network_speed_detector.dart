// lib/utils/network_speed_detector.dart

import 'dart:async';
import 'package:http/http.dart' as http;

class NetworkSpeedDetector {
  static Future<Duration> detectNetworkSpeed() async {
    final stopwatch = Stopwatch()..start();

    try {
      // Ping a reliable endpoint to measure response time
      final response = await http.get(
        Uri.parse('https://www.google.com'),
      ).timeout(const Duration(seconds: 5));

      stopwatch.stop();

      final responseTime = stopwatch.elapsed;

      // Categorize network speed based on response time
      if (responseTime < Duration(milliseconds: 500)) {
        return Duration(milliseconds: 1500); // Fast internet - 2.0 sec
      } else if (responseTime < Duration(milliseconds: 1500)) {
        return Duration(milliseconds: 3000); // Normal internet - 3 sec
      } else {
        return Duration(milliseconds: 5000); // Slow internet - 5 sec
      }
    } catch (e) {
      stopwatch.stop();
      // If network test fails, assume slow connection
      return Duration(milliseconds: 6000); // Very slow - 6 sec
    }
  }

  static Future<NetworkSpeed> getNetworkSpeedCategory() async {
    final duration = await detectNetworkSpeed();

    if (duration < Duration(milliseconds: 2000)) {
      return NetworkSpeed.fast;
    } else if (duration < Duration(milliseconds: 4000)) {
      return NetworkSpeed.normal;
    } else {
      return NetworkSpeed.slow;
    }
  }
}

enum NetworkSpeed {
  fast,
  normal,
  slow,
}