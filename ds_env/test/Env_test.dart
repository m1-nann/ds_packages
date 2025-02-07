import 'package:ds_env/Env.dart';
import 'package:test/test.dart';

main () {
  final env = Env('test/secrets.env');
  test('Should find env', () {
    expect(env['Name'], 'Nhan Nguyen');
  });
  test('Should throw error', () {
    expect(() => env['Not found'], throwsA(TypeMatcher<String>()));
  });
}