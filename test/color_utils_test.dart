import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:color_palette/utils/color_utils.dart';

void main() {
  test('hex formats RGB color correctly', () {
    const color = Color(0xFFFF5733);
    expect(ColorFormatter.hex(color), '#FF5733');
  });

  test('rgb formats color correctly', () {
    const color = Color(0xFFFF5733);
    expect(ColorFormatter.rgb(color), 'rgb(255, 87, 51)');
  });

  test('palette generates many colors', () {
    final palette = ColorGenerator.generatePalette();
    expect(palette.length, greaterThan(100));
  });
}
