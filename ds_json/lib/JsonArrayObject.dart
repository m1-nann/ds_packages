part of '../ds_json.dart';

/// JSON array accessor for accessing elements by index.
///
/// Usage: Extend this class and use `late final` fields with getters:
/// ```dart
/// class Point extends JsonArrayObject {
///   Point(super.data);
///   late final double x = getDouble(0);
///   late final double y = getDouble(1);
///   late final double z = getDouble(2);
/// }
/// ```
class JsonArrayObject {
  final List<dynamic> _data;

  JsonArrayObject(this._data);

  List<dynamic> rawData() => _data;

  double? _parseDouble(dynamic item, {int? index}) {
    if (item is int) {
      return item.toDouble();
    } else if (item is double) {
      return item;
    } else if (item == null) {
      return null;
    } else if (item is String) {
      return double.parse(item);
    } else {
      throw 'Unhandled data type index[${index}] runtimeType=${item.runtimeType} data=${item}';
    }
  }

  /// Nullable getters
  int? getIntNullable(int index) {
    final item = _data[index];
    try {
      if (item is int) {
        return item;
      } else if (item == null) {
        return null;
      } else if (item is String) {
        return int.parse(item);
      } else {
        throw 'Unhandled data type index[${index}] runtimeType=${item.runtimeType} data=${item}';
      }
    } catch (e) {
      throw 'Invalid data format index[${index}] runtimeType=${item.runtimeType} data=${item}: ${e.toString()}';
    }
  }

  double? getDoubleNullable(int index) {
    final item = _data[index];
    try {
      return _parseDouble(item, index: index);
    } catch (e) {
      throw 'Invalid data format index[${index}] runtimeType=${item.runtimeType} data=${item}: ${e.toString()}';
    }
  }

  bool? getBoolNullable(int index) {
    final item = _data[index];
    try {
      if (item is bool) {
        return item;
      } else if (item == null) {
        return null;
      } else if (item is String) {
        return bool.parse(item);
      } else {
        throw 'Unhandled data type index[${index}] runtimeType=${item.runtimeType} data=${item}';
      }
    } catch (e) {
      throw 'Invalid data format index[${index}] runtimeType=${item.runtimeType} data=${item}: ${e.toString()}';
    }
  }

  String? getStringNullable(int index) {
    final item = _data[index];
    try {
      if (item is String) {
        return item;
      } else if (item == null) {
        return null;
      } else {
        throw 'Unhandled data type index[${index}] runtimeType=${item.runtimeType} data=${item}';
      }
    } catch (e) {
      throw 'Invalid data format index[${index}] runtimeType=${item.runtimeType} data=${item}: ${e.toString()}';
    }
  }

  DateTime? getDateTimeNullable(int index) {
    final item = _data[index];
    try {
      if (item is DateTime) {
        return item;
      } else if (item is int) {
        return DateTime.fromMillisecondsSinceEpoch(item);
      } else if (item == null) {
        return null;
      } else if (item is String) {
        return DateTime.parse(item);
      } else {
        throw 'Unhandled data type index[${index}] runtimeType=${item.runtimeType} data=${item}';
      }
    } catch (e) {
      throw 'Invalid data format index[${index}] runtimeType=${item.runtimeType} data=${item}: ${e.toString()}';
    }
  }

  JsonMapObject? getObjectNullable(int index) {
    final item = _data[index];
    if (item == null) return null;
    return JsonMapObject(item as Map<String, dynamic>);
  }

  /// Error free, non-null default value getters
  int getInt(int index) {
    try {
      return getIntNullable(index) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  double getDouble(int index) {
    try {
      return getDoubleNullable(index) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  DateTime getDateTime(int index) {
    try {
      return getDateTimeNullable(index) ?? DateTime.fromMillisecondsSinceEpoch(0);
    } catch (e) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  String getString(int index) {
    try {
      return getStringNullable(index) ?? '';
    } catch (e) {
      return '';
    }
  }

  bool getBool(int index) {
    try {
      return getBoolNullable(index) ?? false;
    } catch (e) {
      return false;
    }
  }

  JsonMapObject getObject(int index) => JsonMapObject(_data[index] as Map<String, dynamic>);
}
