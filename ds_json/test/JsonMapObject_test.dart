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
  });
}