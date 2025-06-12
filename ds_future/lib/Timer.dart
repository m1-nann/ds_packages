part of 'ds_future.dart';

/// Creates a [Timer] that executes the [callback] immediately
Timer periodicNow(Duration duration, void Function(Timer t) callback) {
  final t =  Timer.periodic(duration, callback);
  callback(t);
  return t;
}

