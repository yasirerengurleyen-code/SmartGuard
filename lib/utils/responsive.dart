import 'package:flutter/material.dart';

import 'constants.dart';

/// Centers content and clamps width on tablets / large screens.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth = AppConstants.maxContentWidth,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: AppConstants.pagePadding,
              ),
          child: child,
        ),
      ),
    );
  }
}

double responsiveValue(
  BuildContext context, {
  required double compact,
  double? medium,
  double? expanded,
}) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= 900) return expanded ?? medium ?? compact;
  if (width >= 600) return medium ?? compact;
  return compact;
}
