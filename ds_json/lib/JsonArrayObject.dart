part of '../ds_json.dart';

class JsonArrayObject {
  final List<dynamic> _data;

  JsonArrayObject(this._data);

  List<dynamic> rawData() => _data;

  double getDouble(int index) {
    try {
      return double.parse((_data[index] ?? '0') as String);
    } catch (e) {
      throw 'Invalid data format index[${index}] runtimeType=${_data[index].runtimeType} data=${_data}: ${e.toString()}';
    }
  }

  int getInt(int index) => (_data[index] ?? 0) as int;

  String getString(int index) => (_data[index] ?? '') as String;

  JsonMapObject getObject(int index) => JsonMapObject(_data[index] as Map<String, dynamic>);
}
