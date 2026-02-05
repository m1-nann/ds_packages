# ds_json

Type-safe JSON accessors with dot-notation support.

## Usage

Extend `JsonMapObject` and use `late final` fields:

```dart
class Task extends JsonMapObject {
  Task(super.data);

  late final String id = getString("id");
  late final String status = getString("payment.status");
  late final int amount = getInt("payment.amount");
  late final DateTime createdAt = getDateTime("created_at");
  late final List<String> tags = getListString("tags");
  late final List<Item> items = getList("items", Item.new);
}
```

For array data, extend `JsonArrayObject`:

```dart
class Point extends JsonArrayObject {
  Point(super.data);

  late final double x = getDouble(0);
  late final double y = getDouble(1);
}
```
