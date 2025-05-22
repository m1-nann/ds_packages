part of 'ds_json.dart';

class JsonMapObject {
  final dynamic _data;

  JsonMapObject(this._data) {
    if (!(_data is Map<String, dynamic>)) {
      throw 'data must be Map<String, dynamic>';
    }
  }

  Map<String, dynamic> rawData() => _data;

  /// Get value recursively from nested object
  static dynamic _getRecursive(List<String> keys, dynamic data) {
    assert(keys.isNotEmpty);
    final item = data[keys.first];

    if (keys.length == 1) {
      return item;
    } else if (item is Map<String, dynamic>) {
      return _getRecursive(keys.sublist(1), item);
    } else {
      return null;
    }
  }

  dynamic _get(String key) {
    final keys = key.split('.').where((e) => e.isNotEmpty).toList();
    if (keys.isEmpty) {
      return null;
    }
    return _getRecursive(keys, _data);
  }

  /// Primary type parser
  double? _parseDouble(dynamic item, {String? key}) {
    if (item is int) {
      return item.toDouble();
    } else if (item is double) {
      return item;
    } else if (item == null) {
      return null;
    } else if (item is String) {
      return double.parse(item);
    } else {
      throw 'Unhandled data type key[${key}] runtimeType=${item.runtimeType} data=${item}';
    }
  }

  /// Nullable getters
  int? getIntNullable(String key) {
    final item = _get(key);
    try {
      if (item is int) {
        return item;
      } else if (item == null) {
        return null;
      } else if (item is String) {
        return int.parse(item);
      } else {
        throw 'Unhandled data type key[${key}] runtimeType=${item.runtimeType} data=${item}';
      }
    } catch (e) {
      throw 'Invalid data format key[${key}] runtimeType=${item.runtimeType} data=${item}: ${e.toString()}';
    }
  }

  double? getDoubleNullable(String key) {
    final item = _get(key);
    try {
      return _parseDouble(item, key: key);
    } catch (e) {
      throw 'Invalid data format key[${key}] runtimeType=${item.runtimeType} data=${item}: ${e.toString()}';
    }
  }

  bool? getBoolNullable(String key) {
    final item = _get(key);
    try {
      if (item is bool) {
        return item;
      } else if (item == null) {
        return null;
      } else if (item is String) {
        return bool.parse(item);
      } else {
        throw 'Unhandled data type key[${key}] runtimeType=${item.runtimeType} data=${item}';
      }
    } catch (e) {
      throw 'Invalid data format key[${key}] runtimeType=${item.runtimeType} data=${item}: ${e.toString()}';
    }
  }

  String? getStringNullable(String key) {
    final item = _get(key);
    try {
      if (item is String) {
        return item;
      } else if (item == null) {
        return null;
      } else {
        throw 'Unhandled data type key[${key}] runtimeType=${item.runtimeType} data=${item}';
      }
    } catch (e) {
      throw 'Invalid data format key[${key}] runtimeType=${item.runtimeType} data=${item}: ${e.toString()}';
    }
  }

  DateTime? getDateTimeNullable(String key) {
    final item = _get(key);
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
        throw 'Unhandled data type key[${key}] runtimeType=${item.runtimeType} data=${item}';
      }
    } catch (e) {
      throw 'Invalid data format key[${key}] runtimeType=${item.runtimeType} data=${item}: ${e.toString()}';
    }
  }

  List<T>? getListNullable<T>(
      String key, T Function(Map<String, dynamic> data) creator) {
    try {
      final item = _get(key);
      if (item is List) {
        return item.map((dynamic e) => creator(e)).toList();
      } else {
        throw 'Unhandled data type key[${key}] runtimeType=${item.runtimeType}';
      }
    } catch (e) {
      throw 'Invalid data format key[${key}] expect=List runtimeType=${_data[key].runtimeType}: ${e.toString()}';
    }
  }

  List<double>? getListOfDoubleNullable(String key) {
    try {
      final item = _get(key);
      if (item is List) {
        return item.map((dynamic e) {
          return _parseDouble(e, key: key) ?? 0;
        }).toList();
      } else {
        throw 'Unhandled data type key[${key}] runtimeType=${item.runtimeType}';
      }
    } catch (e) {
      throw 'Invalid data format key[${key}] expect=List runtimeType=${_data[key].runtimeType}: ${e.toString()}';
    }
  }

  /// Error free, non-null default value getters
  int getInt(String key) {
    try {
      return getIntNullable(key) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  double getDouble(String key) {
    try {
      return getDoubleNullable(key) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  DateTime getDateTime(String key) {
    try {
      return getDateTimeNullable(key) ?? DateTime.fromMillisecondsSinceEpoch(0);
    } catch (e) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  String getString(String key) {
    try {
      return getStringNullable(key) ?? '';
    } catch (e) {
      return '';
    }
  }

  bool getBool(String key) {
    try {
      return getBoolNullable(key) ?? false;
    } catch (e) {
      return false;
    }
  }

  List<T> getList<T>(
      String key, T Function(Map<String, dynamic> data) creator) {
    try {
      return getListNullable(key, creator) ?? [];
    } catch (e) {
      return [];
    }
  }

  List<double> getListOfDouble(String key) {
    try {
      return getListOfDoubleNullable(key) ?? [];
    } catch (e) {
      return [];
    }
  }

  /// Deprecated
  bool hasKey(String key) => _data[key] != null;

  String getStringRecursive(List<String> keys) {
    assert(keys.isNotEmpty);
    if (keys.length == 1) {
      return getString(keys.first);
    } else {
      return getObjectOrNull(keys.first)?.getStringRecursive(keys.sublist(1)) ??
          '';
    }
  }

  String? getStringRecursiveOrNull(List<String> keys) {
    assert(keys.isNotEmpty);
    if (keys.length == 1) {
      return getStringOrNull(keys.first);
    } else {
      return getObjectOrNull(keys.first)
          ?.getStringRecursiveOrNull(keys.sublist(1));
    }
  }

  String? getStringOrNull(String key) =>
      _data[key] == null ? null : _data[key] as String;

  JsonMapObject getObject(String key) => _data[key] is Map<String, dynamic>
      ? JsonMapObject(_data[key] as Map<String, dynamic>)
      : throw 'Invalid data format key[${key}] expect=Map runtimeType=${_data[key].runtimeType}';

  JsonMapObject? getObjectOrNull(String key) => _data[key] == null
      ? null
      : JsonMapObject(_data[key] as Map<String, dynamic>);

  Map<String, dynamic> getObjectData(String key) => _data[key]
          is Map<String, dynamic>
      ? _data[key] as Map<String, dynamic>
      : throw 'Invalid data format key[${key}] expect=Map runtimeType=${_data[key].runtimeType}';

  Map<String, dynamic>? getObjectDataOrNull(String key) =>
      _data[key] == null ? null : getObjectData(key);

  List<T> getListOfArray<T>(
      String key, T Function(List<dynamic> data) creator) {
    try {
      return ((_data[key] ?? <dynamic>[]) as List<dynamic>)
          .map((dynamic e) => creator(e))
          .toList();
    } catch (e) {
      throw 'Invalid data format key[${key}] expect=List runtimeType=${_data[key].runtimeType}: ${e.toString()}';
    }
  }

  List<String> getListString(String key) =>
      ((_data[key] ?? <dynamic>[]) as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList();

  List<String> getListStringRecursive(List<String> keys) {
    if (keys.length == 1) {
      return ((_data[keys[0]] ?? <dynamic>[]) as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList();
    } else {
      return getObjectOrNull(keys.first)
              ?.getListStringRecursive(keys.sublist(1)) ??
          [];
    }
  }

  List<T> getListRecursive<T>(
      List<String> keys, T Function(Map<String, dynamic> data) creator) {
    assert(keys.isNotEmpty);
    if (keys.length == 1) {
      return getList(keys.first, creator);
    } else {
      return getObjectOrNull(keys.first)
              ?.getListRecursive(keys.sublist(1), creator) ??
          [];
    }
  }

  List<T> getListOfArrayRecursive<T>(
      List<String> keys, T Function(List<dynamic> data) creator) {
    assert(keys.isNotEmpty);
    if (keys.length == 1) {
      return getListOfArray(keys.first, creator);
    } else {
      return getObjectOrNull(keys.first)
              ?.getListOfArrayRecursive(keys.sublist(1), creator) ??
          [];
    }
  }
}
