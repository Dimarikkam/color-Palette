import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/color_utils.dart';
import '../utils/responsive.dart';
import '../widgets/color_info_panel.dart';
import '../widgets/color_palette_grid.dart';

class ColorPickerScreen extends StatefulWidget {
  const ColorPickerScreen({super.key});

  @override
  State<ColorPickerScreen> createState() => _ColorPickerScreenState();
}

class _ColorPickerScreenState extends State<ColorPickerScreen> {
  late Color _selectedColor;
  late final List<Color> _palette;
  bool _showPalette = true;

  @override
  void initState() {
    super.initState();
    _palette = ColorGenerator.generatePalette();
    _selectedColor = _palette.first;
  }

  void _onColorSelected(Color color) {
    setState(() => _selectedColor = color);
    HapticFeedback.selectionClick();
  }

  void _togglePalette() {
    setState(() => _showPalette = !_showPalette);
  }

  @override
  Widget build(BuildContext context) {
    final isLight = ColorFormatter.isLight(_selectedColor);
    final foreground = isLight ? Colors.black87 : Colors.white;
    final isMobile = ResponsiveLayout.isMobile(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: _selectedColor,
        systemNavigationBarIconBrightness:
            isLight ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _selectedColor,
        body: SafeArea(
          bottom: !isMobile,
          child: isMobile
              ? _buildMobileLayout(foreground)
              : _buildDesktopLayout(foreground),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(Color foreground) {
    return Stack(
      children: [
        Column(
          children: [
            _buildHeader(foreground, compact: true),
            if (!_showPalette) _buildColorPreview(foreground),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _showPalette
                    ? ColorPaletteGrid(
                        key: const ValueKey('palette'),
                        colors: _palette,
                        selectedColor: _selectedColor,
                        onColorSelected: _onColorSelected,
                      )
                    : const SizedBox(key: ValueKey('empty')),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.28,
          minChildSize: 0.18,
          maxChildSize: 0.55,
          snap: true,
          snapSizes: const [0.18, 0.28, 0.55],
          builder: (context, scrollController) {
            return ColorInfoPanel(
              color: _selectedColor,
              foreground: foreground,
              scrollController: scrollController,
              isMobile: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(Color foreground) {
    return Column(
      children: [
        _buildHeader(foreground),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _showPalette
                ? ColorPaletteGrid(
                    key: const ValueKey('palette'),
                    colors: _palette,
                    selectedColor: _selectedColor,
                    onColorSelected: _onColorSelected,
                  )
                : Center(
                    key: const ValueKey('preview'),
                    child: _buildColorPreview(foreground, large: true),
                  ),
          ),
        ),
        ColorInfoPanel(
          color: _selectedColor,
          foreground: foreground,
        ),
      ],
    );
  }

  Widget _buildColorPreview(Color foreground, {bool large = false}) {
    final hex = ColorFormatter.hex(_selectedColor);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.palette_outlined,
            size: large ? 120 : 64,
            color: foreground.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 12),
          Text(
            hex,
            style: TextStyle(
              color: foreground,
              fontSize: large ? 36 : 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color foreground, {bool compact = false}) {
    final hex = ColorFormatter.hex(_selectedColor);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        compact ? 12 : 16,
        compact ? 4 : 8,
        compact ? 4 : 8,
        compact ? 4 : 8,
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 36 : 40,
            height: compact ? 36 : 40,
            decoration: BoxDecoration(
              color: _selectedColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: foreground.withValues(alpha: 0.35)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Color Palette',
                  style: TextStyle(
                    color: foreground,
                    fontSize: ResponsiveLayout.titleFontSize(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (compact)
                  Text(
                    hex,
                    style: TextStyle(
                      color: foreground.withValues(alpha: 0.85),
                      fontSize: 14,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: _togglePalette,
            iconSize: compact ? 22 : 24,
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(
              _showPalette ? Icons.visibility_off : Icons.grid_view,
              color: foreground,
            ),
            tooltip: _showPalette ? 'Скрыть палитру' : 'Показать палитру',
          ),
        ],
      ),
    );
  }
}
