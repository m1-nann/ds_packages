## 1.6.0

### Breaking Changes
- Remove deprecated `hasKey(String key)` method

### JsonMapObject Fixes
- Fix `getStringOrNull` to use `_get()` with dot-notation support
- Fix `getObject`, `getObjectOrNull`, `getObjectData`, `getObjectDataOrNull` to use `_get()` with dot-notation support
- Fix `getListString` to use `_get()` with dot-notation support
- Fix `getListOfArray` to use `_get()` with dot-notation support

### JsonMapObject New Methods
- Add `getListStringNullable(key)` - nullable variant of `getListString`
- Add `getListInt(key)` - returns `List<int>`, default `[]`
- Add `getListIntNullable(key)` - nullable variant, throws on type error
- Add `getListOfArrayNullable(key, creator)` - nullable variant of `getListOfArray`

### JsonArrayObject Completion
- Fix `getDouble(index)` to handle int/double/string (previously only string parsing)
- Add `_parseDouble` helper for consistent double parsing
- Add `getIntNullable(index)`
- Add `getDoubleNullable(index)`
- Add `getStringNullable(index)`
- Add `getObjectNullable(index)`
- Add `getBool(index)` / `getBoolNullable(index)`
- Add `getDateTime(index)` / `getDateTimeNullable(index)`

## 1.0.0

- add `JsonObject`
