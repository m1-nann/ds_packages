import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

class RowGap extends StatelessWidget {
  const RowGap({
    super.key,
    required this.children,
    this.gap = 16.0,
    this.paddingX = 0,
    this.paddingY = 0,
  });

  final double paddingX;
  final double paddingY;
  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingX, vertical: paddingY),
      child: Row(
        children: [
          for (Widget item in children) ...[
            item,
            if (item != children.last) Gap(gap),
          ]
        ],
      ),
    );
  }
}
