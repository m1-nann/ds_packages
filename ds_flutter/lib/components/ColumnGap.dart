import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Space all items with a gap
/// If item is a Gap, it will not be spaced
class ColumnGap extends StatelessWidget {
  const ColumnGap({
    super.key,
    required this.children,
    this.paddingX = 0,
    this.paddingY = 0,
    this.gap = 16.0,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.showDivider = false,
  });

  const ColumnGap.min({required List<Widget?> children}) : this(mainAxisSize: MainAxisSize.min, children: children);
  const ColumnGap.minWithPadding({required List<Widget?> children}) : this(mainAxisSize: MainAxisSize.min, paddingX: 16, children: children);

  final double paddingX;
  final double paddingY;
  final double gap;
  final List<Widget?> children;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final gap = this.gap;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingX, vertical: paddingY),
      child: Column(
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          for (var item in children)...[
            if (item != children.first && showDivider) Divider(color: Colors.grey),
            if (item != null) item,
            if (item is! Gap && item != children.last) Gap(gap),
          ],
        ],
      ),
    );
  }
}
