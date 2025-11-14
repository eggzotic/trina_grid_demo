import 'dart:math';

extension DateExt on DateTime {
  static const secondsPerYear = 60 * 60 * 24 * 365.25;
  static final random = Random();

  DateTime getRandomDateUpTo([int years = 100]) {
    final maxRangeInSeconds = (years * secondsPerYear).floor();
    final randomNumber = random.nextInt(maxRangeInSeconds);
    final randomSeconds = (millisecondsSinceEpoch / 1000 + randomNumber)
        .floor();
    return DateTime.fromMillisecondsSinceEpoch(randomSeconds * 1000);
  }
}
