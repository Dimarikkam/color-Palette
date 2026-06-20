import 'package:flutter/material.dart';

class ResponsiveLayout {
  ResponsiveLayout._();

  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static int paletteColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    const horizontalPadding = 24.0;
    const gridPadding = 16.0;
    final minCellSize = isMobile(context) ? 44.0 : 36.0;
    final available = width - horizontalPadding - gridPadding;
    return (available / minCellSize).floor().clamp(5, 12);
  }

  static double headerIconSize(BuildContext context) =>
      isMobile(context) ? 24.0 : 28.0;

  static double titleFontSize(BuildContext context) =>
      isMobile(context) ? 20.0 : 22.0;

  static EdgeInsets screenPadding(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: isMobile(context) ? 12 : 16);
}
