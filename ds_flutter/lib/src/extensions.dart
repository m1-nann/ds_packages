part of '../ds_flutter.dart';

extension StringExtension on String {
  Uri get toUri => Uri.parse(this);
}

extension BuildContextExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  void push(Widget page) {
    Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));
  }
}


