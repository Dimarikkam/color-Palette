import 'package:flutter/material.dart';

/// Генерирует полную палитру цветов по HSL-пространству.
class ColorGenerator {
  ColorGenerator._();

  static const _materialShades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];

  static List<Color> generatePalette() {
    final colors = <Color>{};

    for (final swatch in Colors.primaries) {
      for (final shade in _materialShades) {
        colors.add(swatch[shade]!);
      }
    }
    colors.addAll([
      Colors.black,
      Colors.white,
      Colors.grey.shade100,
      Colors.grey.shade200,
      Colors.grey.shade300,
      Colors.grey.shade400,
      Colors.grey.shade500,
      Colors.grey.shade600,
      Colors.grey.shade700,
      Colors.grey.shade800,
      Colors.grey.shade900,
    ]);

    const hueSteps = 36;
    const satSteps = 5;
    const lightSteps = 5;

    for (var h = 0; h < hueSteps; h++) {
      final hue = h * (360 / hueSteps);
      for (var s = 1; s <= satSteps; s++) {
        final saturation = s / satSteps;
        for (var l = 1; l <= lightSteps; l++) {
          final lightness = l / (lightSteps + 1);
          colors.add(_hslToColor(hue, saturation, lightness));
        }
      }
    }

    final sorted = colors.toList()
      ..sort((a, b) {
        final ha = HSLColor.fromColor(a).hue;
        final hb = HSLColor.fromColor(b).hue;
        if (ha != hb) return ha.compareTo(hb);
        final sa = HSLColor.fromColor(a).saturation;
        final sb = HSLColor.fromColor(b).saturation;
        if (sa != sb) return sa.compareTo(sb);
        return HSLColor.fromColor(a).lightness.compareTo(
              HSLColor.fromColor(b).lightness,
            );
      });

    return sorted;
  }

  static Color _hslToColor(double h, double s, double l) {
    return HSLColor.fromAHSL(1, h, s, l).toColor();
  }
}

/// Утилиты для форматирования кодов цвета.
class ColorFormatter {
  ColorFormatter._();

  static int _byte(double channel) =>
      (channel * 255.0).round().clamp(0, 255);

  static String hex(Color color, {bool withAlpha = false}) {
    if (withAlpha) {
      return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    }
    final r = _byte(color.r).toRadixString(16).padLeft(2, '0');
    final g = _byte(color.g).toRadixString(16).padLeft(2, '0');
    final b = _byte(color.b).toRadixString(16).padLeft(2, '0');
    return '#${(r + g + b).toUpperCase()}';
  }

  static String rgb(Color color) =>
      'rgb(${_byte(color.r)}, ${_byte(color.g)}, ${_byte(color.b)})';

  static String rgba(Color color) =>
      'rgba(${_byte(color.r)}, ${_byte(color.g)}, ${_byte(color.b)}, ${color.a.toStringAsFixed(2)})';

  static String hsl(Color color) {
    final hsl = HSLColor.fromColor(color);
    return 'hsl(${hsl.hue.round()}, ${(hsl.saturation * 100).round()}%, ${(hsl.lightness * 100).round()}%)';
  }

  static String flutter(Color color) {
    return 'Color(0x${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()})';
  }

  static bool isLight(Color color) {
    return color.computeLuminance() > 0.5;
  }
}
