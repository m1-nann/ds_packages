import 'package:ds_future/ds_future.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UseTextController {
  const UseTextController({required this.controller, required this.text});

  final TextEditingController controller;
  final String text;

  clear() {
    controller.clear();
  }
}

UseTextController useTextController({
  String initialValue = "",
  int throttle = 0,
}) {
  final text = useState<String>(initialValue);
  final throttleFunction = useMemoized(() => DelayThrottle(throttle), []);

  final controller = useMemoized(() {
    final controller = TextEditingController();
    controller.text = initialValue;
    controller.addListener(() {
      if (throttle > 0) {
        throttleFunction <<
            () {
              text.value = controller.text;
            };
      } else {
        text.value = controller.text;
      }
    });
    return controller;
  }, []);

  return UseTextController(controller: controller, text: text.value);
}
