Usage 

```dart
class SomeApiResponse extends JsonMapObject {
  late final String message = getString('message'); 
  
  SomeApiResponse(data): super(data);
}
```
