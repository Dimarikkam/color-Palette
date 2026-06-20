import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:color_palette/main.dart';

void main() {
  testWidgets('App launches color picker screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ColorPaletteApp());
    await tester.pumpAndSettle();

    expect(find.text('Color Palette'), findsOneWidget);
    expect(find.text('Код цвета'), findsOneWidget);
  });

  testWidgets('Mobile layout shows draggable color panel hint',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ColorPaletteApp());
    await tester.pumpAndSettle();

    expect(
      find.text('Нажмите на строку, чтобы скопировать'),
      findsOneWidget,
    );
  });
}
