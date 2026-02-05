import 'package:ds_json/ds_json.dart';
import 'package:test/test.dart';

main () {
  group("JsonMapObject", () {
    test("getDouble", () {
      final o = JsonMapObject({
        "data": {
          "date": "2025-03-06",
          "double_string": "50.00",
          "double": 50.00,
          "double_int": 50,
          "double_null": null,
        }
      });
      expect(o.getDouble("data.date"), 0.0);
      expect(o.getDouble("data.double_string"), 50.0);
      expect(o.getDouble("data.double"), 50.0);
      expect(o.getDouble("data.double_int"), 50.0);
      expect(o.getDouble("data.double_null"), 0.0);
      expect(o.getDouble("data.null"), 0.0);
      expect(o.getDouble("null"), 0.0);
      expect(o.getDouble(""), 0.0);
    });

    test("getDateTime", () {
      final o = JsonMapObject({
        "data": {
          "date_string": "2025-03-06",
          "date_string_2": "2025-01-13T04:36:43.000000Z",
          "date": DateTime(2025,03,06),
          "date_int": DateTime(2025,03,06).millisecondsSinceEpoch,
          "date_invalid": "invalid",
          "date_null": null,
        }
      });
      expect(o.getDateTime("data.date_string"), DateTime(2025,03,06));
      expect(o.getDateTime("data.date_string_2"), DateTime.utc(2025,01,13,04,36,43));
      expect(o.getDateTime("data.date"), DateTime(2025,03,06));
      expect(o.getDateTime("data.date_int"), DateTime(2025,03,06));
      expect(o.getDateTime("data.invalid"), DateTime.fromMillisecondsSinceEpoch(0));
      expect(o.getDateTime("data.date_null"), DateTime.fromMillisecondsSinceEpoch(0));
    });

    test("getStringOrNull with dot-notation", () {
      final o = JsonMapObject({
        "a": {
          "b": {
            "c": "nested_value"
          },
          "value": "direct_value"
        },
        "null_value": null,
      });
      expect(o.getStringOrNull("a.b.c"), "nested_value");
      expect(o.getStringOrNull("a.value"), "direct_value");
      expect(o.getStringOrNull("null_value"), null);
      expect(o.getStringOrNull("missing"), null);
      expect(o.getStringOrNull("a.missing"), null);
    });

    test("getObject with dot-notation", () {
      final o = JsonMapObject({
        "level1": {
          "level2": {
            "target": {"value": "found"}
          }
        }
      });
      final obj = o.getObject("level1.level2.target");
      expect(obj.getString("value"), "found");
    });

    test("getObjectOrNull with dot-notation", () {
      final o = JsonMapObject({
        "level1": {
          "level2": {
            "target": {"value": "found"}
          }
        }
      });
      final obj = o.getObjectOrNull("level1.level2.target");
      expect(obj?.getString("value"), "found");
      expect(o.getObjectOrNull("missing.path"), null);
      expect(o.getObjectOrNull("level1.missing"), null);
    });

    test("getObjectData with dot-notation", () {
      final o = JsonMapObject({
        "level1": {
          "level2": {"key": "value"}
        }
      });
      final data = o.getObjectData("level1.level2");
      expect(data["key"], "value");
    });

    test("getObjectDataOrNull with dot-notation", () {
      final o = JsonMapObject({
        "level1": {
          "level2": {"key": "value"}
        }
      });
      expect(o.getObjectDataOrNull("level1.level2")?["key"], "value");
      expect(o.getObjectDataOrNull("missing.path"), null);
    });

    test("getListString with dot-notation", () {
      final o = JsonMapObject({
        "data": {
          "tags": ["a", "b", "c"]
        },
        "empty": []
      });
      expect(o.getListString("data.tags"), ["a", "b", "c"]);
      expect(o.getListString("empty"), []);
      expect(o.getListString("missing"), []);
    });

    test("getListStringNullable", () {
      final o = JsonMapObject({
        "data": {
          "tags": ["a", "b", "c"]
        },
        "null_value": null,
      });
      expect(o.getListStringNullable("data.tags"), ["a", "b", "c"]);
      expect(o.getListStringNullable("null_value"), null);
      expect(o.getListStringNullable("missing"), null);
    });

    test("getListInt", () {
      final o = JsonMapObject({
        "data": {
          "numbers": [1, 2, 3]
        },
        "empty": []
      });
      expect(o.getListInt("data.numbers"), [1, 2, 3]);
      expect(o.getListInt("empty"), []);
      expect(o.getListInt("missing"), []);
    });

    test("getListIntNullable", () {
      final o = JsonMapObject({
        "data": {
          "numbers": [1, 2, 3]
        },
        "null_value": null,
      });
      expect(o.getListIntNullable("data.numbers"), [1, 2, 3]);
      expect(o.getListIntNullable("null_value"), null);
      expect(o.getListIntNullable("missing"), null);
    });

    test("getListOfArray with dot-notation", () {
      final o = JsonMapObject({
        "data": {
          "points": [[1, 2], [3, 4]]
        }
      });
      final points = o.getListOfArray("data.points", (arr) => "${arr[0]},${arr[1]}");
      expect(points, ["1,2", "3,4"]);
    });

    test("getListOfArrayNullable", () {
      final o = JsonMapObject({
        "data": {
          "points": [[1, 2], [3, 4]]
        },
        "null_value": null,
      });
      final points = o.getListOfArrayNullable("data.points", (arr) => "${arr[0]},${arr[1]}");
      expect(points, ["1,2", "3,4"]);
      expect(o.getListOfArrayNullable("null_value", (arr) => arr), null);
      expect(o.getListOfArrayNullable("missing", (arr) => arr), null);
    });
  });
}
