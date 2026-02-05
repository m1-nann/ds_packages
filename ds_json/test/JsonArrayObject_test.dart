import 'package:ds_json/ds_json.dart';
import 'package:test/test.dart';

main() {
  group("JsonArrayObject", () {
    test("getDouble", () {
      final arr = JsonArrayObject([50, 25.5, "30.0", null, "invalid"]);
      expect(arr.getDouble(0), 50.0);
      expect(arr.getDouble(1), 25.5);
      expect(arr.getDouble(2), 30.0);
      expect(arr.getDouble(3), 0.0);
      expect(arr.getDouble(4), 0.0);
    });

    test("getDoubleNullable", () {
      final arr = JsonArrayObject([50, 25.5, "30.0", null]);
      expect(arr.getDoubleNullable(0), 50.0);
      expect(arr.getDoubleNullable(1), 25.5);
      expect(arr.getDoubleNullable(2), 30.0);
      expect(arr.getDoubleNullable(3), null);
    });

    test("getInt", () {
      final arr = JsonArrayObject([50, "30", null, "invalid"]);
      expect(arr.getInt(0), 50);
      expect(arr.getInt(1), 30);
      expect(arr.getInt(2), 0);
      expect(arr.getInt(3), 0);
    });

    test("getIntNullable", () {
      final arr = JsonArrayObject([50, "30", null]);
      expect(arr.getIntNullable(0), 50);
      expect(arr.getIntNullable(1), 30);
      expect(arr.getIntNullable(2), null);
    });

    test("getString", () {
      final arr = JsonArrayObject(["hello", "world", null]);
      expect(arr.getString(0), "hello");
      expect(arr.getString(1), "world");
      expect(arr.getString(2), "");
    });

    test("getStringNullable", () {
      final arr = JsonArrayObject(["hello", null]);
      expect(arr.getStringNullable(0), "hello");
      expect(arr.getStringNullable(1), null);
    });

    test("getBool", () {
      final arr = JsonArrayObject([true, false, "true", "false", null, "invalid"]);
      expect(arr.getBool(0), true);
      expect(arr.getBool(1), false);
      expect(arr.getBool(2), true);
      expect(arr.getBool(3), false);
      expect(arr.getBool(4), false);
      expect(arr.getBool(5), false);
    });

    test("getBoolNullable", () {
      final arr = JsonArrayObject([true, false, "true", "false", null]);
      expect(arr.getBoolNullable(0), true);
      expect(arr.getBoolNullable(1), false);
      expect(arr.getBoolNullable(2), true);
      expect(arr.getBoolNullable(3), false);
      expect(arr.getBoolNullable(4), null);
    });

    test("getDateTime", () {
      final now = DateTime(2025, 3, 6);
      final arr = JsonArrayObject([
        now,
        now.millisecondsSinceEpoch,
        "2025-03-06",
        null,
        "invalid"
      ]);
      expect(arr.getDateTime(0), now);
      expect(arr.getDateTime(1), now);
      expect(arr.getDateTime(2), DateTime(2025, 3, 6));
      expect(arr.getDateTime(3), DateTime.fromMillisecondsSinceEpoch(0));
      expect(arr.getDateTime(4), DateTime.fromMillisecondsSinceEpoch(0));
    });

    test("getDateTimeNullable", () {
      final now = DateTime(2025, 3, 6);
      final arr = JsonArrayObject([
        now,
        now.millisecondsSinceEpoch,
        "2025-03-06",
        null
      ]);
      expect(arr.getDateTimeNullable(0), now);
      expect(arr.getDateTimeNullable(1), now);
      expect(arr.getDateTimeNullable(2), DateTime(2025, 3, 6));
      expect(arr.getDateTimeNullable(3), null);
    });

    test("getObject", () {
      final arr = JsonArrayObject([{"name": "test", "value": 42}]);
      final obj = arr.getObject(0);
      expect(obj.getString("name"), "test");
      expect(obj.getInt("value"), 42);
    });

    test("getObjectNullable", () {
      final arr = JsonArrayObject([{"name": "test"}, null]);
      expect(arr.getObjectNullable(0)?.getString("name"), "test");
      expect(arr.getObjectNullable(1), null);
    });
  });
}
