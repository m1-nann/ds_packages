import 'package:ds_flutter/ds_flutter.dart';
import 'package:flutter/material.dart';

abstract class BaseButton extends StatelessWidget {
  BaseButton({super.key, this.onPressed});

  VoidCallback? onPressed;
  Widget? nextPage;

  handleOnPressed(BuildContext context) {
    final nextPage = this.nextPage;
    if (nextPage != null) {
      context.push(nextPage);
    }
    else {
      onPressed?.call();
    }
  }

  operator >>(dynamic value) {
    if (value is Widget){
      nextPage = value;
    }
    else if (value is void Function() ){
      onPressed = value;
    }
    else {
      throw Exception("Unhandled value type ${value.runtimeType}");
    }
    return this;
  }
}
