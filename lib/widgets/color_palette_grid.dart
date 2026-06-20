import 'package:flutter/material.dart';

import '../utils/responsive.dart';

class ColorPaletteGrid extends StatelessWidget {
  const ColorPaletteGrid({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final columns = ResponsiveLayout.paletteColumns(context);
    final spacing = isMobile ? 6.0 : 4.0;
    final radius = isMobile ? 8.0 : 6.0;
    final selectedBorder = isMobile ? 3.0 : 2.5;

    return Container(
      margin: ResponsiveLayout.screenPadding(context),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(isMobile ? 20 : 16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isMobile ? 20 : 16),
        child: GridView.builder(
          padding: EdgeInsets.all(isMobile ? 10 : 8),
          physics: isMobile
              ? const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                )
              : null,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: colors.length,
          itemBuilder: (context, index) {
            final color = colors[index];
            final isSelected =
                color.toARGB32() == selectedColor.toARGB32();

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onColorSelected(color),
                borderRadius: BorderRadius.circular(radius),
                splashColor: Colors.white.withValues(alpha: 0.3),
                highlightColor: Colors.white.withValues(alpha: 0.15),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(radius),
                    border: isSelected
                        ? Border.all(color: Colors.white, width: selectedBorder)
                        : Border.all(
                            color: Colors.black.withValues(alpha: 0.12),
                            width: 0.5,
                          ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.45),
                              blurRadius: isMobile ? 8 : 6,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check_rounded,
                          color: color.computeLuminance() > 0.5
                              ? Colors.black87
                              : Colors.white,
                          size: isMobile ? 20 : 16,
                        )
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
