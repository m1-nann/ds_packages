import 'dart:math' as math;

import 'package:collection/collection.dart';

export 'package:collection/collection.dart';

final _random = math.Random();

extension IterableExtension<T> on Iterable<T> {
  double sumDouble(double Function(T i) getter) {
    return fold(0, (a, i) => a + getter(i));
  }

  double avgDouble(double Function(T i) getter) {
    return sumDouble(getter) / length;
  }

  double max(double Function(T i) getter) {
    return fold(-double.maxFinite, (a, i) => math.max(a, getter(i)));
  }

  double min(double Function(T i) getter) {
    return fold(double.maxFinite, (a, i) => math.min(a, getter(i)));
  }

  T findMax(double Function(T i) getter) {
    if (this.isEmpty) throw 'Cannot be empty';
    double? currentMax;
    late T ans;
    for (final item in this) {
      if (currentMax == null || getter(item) > currentMax) {
        currentMax = getter(item);
        ans = item;
      }
    }
    return ans;
  }

  double median<K extends dynamic>(double Function(T i) getter) {
    if (this.isEmpty) throw 'Cannot be empty';
    //clone list
    List<T> clonedList = this.sorted((a, b) => getter(a).compareTo(getter(b)));

    double median;

    int middle = clonedList.length ~/ 2;

    if (clonedList.length % 2 == 1) {
      median = getter(clonedList[middle]);
    } else {
      median = ((getter(clonedList[middle - 1]) + getter(clonedList[middle])) / 2.0);
    }

    return median;
  }

  int sumInt(int Function(T item) select) {
    return fold<int>(0, (a, i) => a + select(i));
  }

  Map<K, List<T>> groupBy<K>(K Function(T item) getKey) {
    return fold({}, (a, i) {
      final k = getKey(i);
      if (a[k] == null) {
        a[k] = [i];
      } else {
        a[k]!.add(i);
      }
      return a;
    });
  }

  Map<K, J> groupBySelect<K, J>({
    required K Function(T item) getKey,
    required J Function(K key, List<T> value) aggregate,
  }) {
    final groups = groupBy(getKey);
    return groups.map((key, value) => MapEntry(key, aggregate(key, value)));
  }

  List<T> toFixedList() => this.toList(growable: false);
}

extension ListExtension<T> on List<T> {
  List<List<T>> pack(int before, int after) {
    final ans = <List<T>>[];
    for (int i = before; i < length - after; i++) {
      ans.add(this.sublist(i - before, i + after + 1));
    }
    return ans;
  }

  List<List<T>> splitEvenly(int count) {
    final ans = <List<T>>[];
    final each = length ~/ count;
    for (int i = 0; i < count; i++) {
      ans.add(this.sublist(i * each, (i + 1) * each));
    }
    return ans;
  }

  List<T> everyCount(int offset, int count) {
    final ans = <T>[];
    for (int i = 0; i < count; i++) {
      if ((i - offset) % count == 0) {
        ans.add(this[i]);
      }
    }
    return ans;
  }

  List<T> filterLowDouble(double percent, double Function(T i) getter) {
    final s = sorted((a, b) => getter(a).compareTo(getter(b)));
    return s.sublist(0, (percent * length).ceil());
  }

  List<T> filterHighDouble(double percent, double Function(T i) getter) {
    final s = sorted((a, b) => getter(b).compareTo(getter(a)));
    return s.sublist(0, (percent * length).ceil());
  }

  int indexIdentical(T? b) {
    return indexWhere((i) => identical(b, i));
  }

  bool identicalContains(T? b) {
    return any((element) => identical(b, element));
  }

  bool equals(List<T> b) {
    if (b.length != length) return false;
    for (int i = 0; i < length; i++) {
      if (this[i] != b[i]) return false;
    }
    return true;
  }

  List<T> sublistBackward(int end) {
    return sublist(0, length - end);
  }

  List<T> top(int count) {
    return sublist(0, math.max(0, math.min(count, length)));
  }

  List<T> bottom(int count) {
    return sublist(math.min(length, math.max(0, length - count)), length);
  }

  /// exclusive index
  List<T> before(int index, int count) {
    if (index - count < 0) throw 'index must be >= count';
    if (count <= 0) throw 'count must be >= 0';
    return sublist(index - count, index);
  }

  /// perform fast when count is small
  List<T> random(int count) {
    final List<T> ans = [];
    final Set<int> indices = {};
    final minCount = math.min(count, length);
    while (ans.length < minCount) {
      final index = _random.nextInt(length);
      if (!indices.contains(index)) {
        indices.add(index);
        ans.add(elementAt(index));
      }
    }
    return ans;
  }

  T randomItem() {
    return elementAt(_random.nextInt(length));
  }

  /// return a list of elements from first until [predicate] is true
  /// exclusive [predicate] true element
  /// if no element where [predicate] is true, return empty
  List<T> topUntil(bool Function(T item) predicate, {bool takeAllIfNotFound = false}) {
    final predicateIndex = indexWhere(predicate);
    if (predicateIndex == -1) return takeAllIfNotFound ? [...this] : [];
    return sublist(0, predicateIndex);
  }

  T front(int index) {
    return elementAt(math.min(index, length - 1));
  }

  T back(int index) {
    return elementAt(math.max(length - index - 1, 0));
  }

  int indexWhereOrLast(bool Function(T item) predicate) {
    final index = indexWhere(predicate);
    return index == -1 ? length - 1 : index;
  }

  List<int> indicesWhere(bool Function(T i) predicate) {
    final items = where(predicate);
    return items.map(indexOf).toList(growable: false);
  }

  T? at(int index) => index < length ? this[index] : null;

  /// stop on false
  bool compare(List b) {
    if (length != b.length) return false;
    for (int i = 0; i < length; i++) {
      if (this[i] != b[i]) return false;
    }
    return true;
  }
}

extension MapExtension on Map {
  /// with entries ordered
  bool compare(Map b) {
    if (length != b.length) return false;
    return keys.toList(growable: false).compare(b.keys.toList(growable: false)) && values.toList(growable: false).compare(b.values.toList(growable: false));
  }
}
