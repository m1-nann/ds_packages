import 'dart:io';

class Env {
  final Map<String, String> _env;

  Env(String filepath)
      : _env = Map.fromEntries(File(filepath).readAsStringSync().split('\n').where((i) => i.isNotEmpty && i.contains('=')).map((e) {
          final s = e.split('=');
          return MapEntry(s[0], s[1]);
        }));

  String operator [](String key) {
    if (_env[key] == null) throw 'Env Key[${key}] not found';
    return _env[key]!;
  }
}
