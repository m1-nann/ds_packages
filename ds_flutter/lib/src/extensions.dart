part of '../ds_flutter.dart';

extension StringExtension on String {
  Uri get toUri => Uri.parse(this);
}

extension ListExtension<T> on Iterable<T> {
  List<T> takeLast(int n) {
    if (n < 0) throw ArgumentError('n must be non-negative');
    var list = this.toList();
    if (n > list.length) n = list.length;
    return list.sublist(list.length - n);
  }
}

extension BuildContextExtension on BuildContext {
  double get screenWidth =>
      MediaQuery
          .of(this)
          .size
          .width;

  double get screenHeight =>
      MediaQuery
          .of(this)
          .size
          .height;

  void push(Widget page) {
    Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));
  }

  void showSnackbar({String? message, bool force = true, String? error}) {
    if (mounted) {
      final text = message ?? error;
      final isError = error != null;
      if (text == null) {
        return;
      }
      final colorScheme = Theme
          .of(this)
          .colorScheme;
      final snackBar = SnackBar(
        content: Text(text),
        backgroundColor: isError ? colorScheme.error : null,
      );
      if (force) {
        ScaffoldMessenger.of(this).clearSnackBars();
      }
      ScaffoldMessenger.of(this).showSnackBar(snackBar);
    }
  }

  Future<T?> showPopup<T>(Widget page) {
    return showDialog<T?>(
      context: this,
      builder: (_) => page,
    );
  }

  void openDrawer() {
    Scaffold.of(this).openDrawer();
  }

  ColorScheme get color {
    return Theme
        .of(this)
        .colorScheme;
  }
}
