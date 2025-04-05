Usage 

```dart
class Task extends JsonMapObject {
  late final String id = getString("id");
  late final String status = getString("creditCardDetails.status");
  late final String? creditCardNumber = getStringOrNull("creditCardNumber");
  late final String cardNumber = getString("creditCardDetails.cardNumber");

  Task(super.data);
}
```
