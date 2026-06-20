import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/color_utils.dart';

class ColorInfoPanel extends StatelessWidget {
  const ColorInfoPanel({
    super.key,
    required this.color,
    required this.foreground,
    this.scrollController,
    this.isMobile = false,
  });

  final Color color;
  final Color foreground;
  final ScrollController? scrollController;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final entries = [
      _ColorCodeEntry('HEX', ColorFormatter.hex(color)),
      _ColorCodeEntry('HEX+Alpha', ColorFormatter.hex(color, withAlpha: true)),
      _ColorCodeEntry('RGB', ColorFormatter.rgb(color)),
      _ColorCodeEntry('RGBA', ColorFormatter.rgba(color)),
      _ColorCodeEntry('HSL', ColorFormatter.hsl(color)),
      _ColorCodeEntry('Flutter', ColorFormatter.flutter(color)),
    ];

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMobile) _buildDragHandle(foreground),
        Row(
          children: [
            Container(
              width: isMobile ? 48 : 40,
              height: isMobile ? 48 : 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: foreground.withValues(alpha: 0.3),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Код цвета',
                    style: TextStyle(
                      color: foreground,
                      fontSize: isMobile ? 17 : 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isMobile)
                    Text(
                      'Нажмите на строку, чтобы скопировать',
                      style: TextStyle(
                        color: foreground.withValues(alpha: 0.65),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 14 : 12),
        ...entries.map(
          (e) => _CodeRow(
            label: e.label,
            value: e.value,
            foreground: foreground,
            isMobile: isMobile,
          ),
        ),
        if (isMobile) SizedBox(height: MediaQuery.paddingOf(context).bottom),
      ],
    );

    return Container(
      width: double.infinity,
      margin: isMobile ? EdgeInsets.zero : const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: isMobile ? 0.18 : 0.12),
        borderRadius: isMobile
            ? const BorderRadius.vertical(top: Radius.circular(24))
            : BorderRadius.circular(16),
        border: Border.all(color: foreground.withValues(alpha: 0.2)),
        boxShadow: isMobile
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ]
            : null,
      ),
      child: isMobile
          ? ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [content],
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: content,
            ),
    );
  }

  Widget _buildDragHandle(Color foreground) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 12, top: 4),
        decoration: BoxDecoration(
          color: foreground.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _ColorCodeEntry {
  const _ColorCodeEntry(this.label, this.value);
  final String label;
  final String value;
}

class _CodeRow extends StatelessWidget {
  const _CodeRow({
    required this.label,
    required this.value,
    required this.foreground,
    this.isMobile = false,
  });

  final String label;
  final String value;
  final Color foreground;
  final bool isMobile;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: value));
    HapticFeedback.lightImpact();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Скопировано: $value',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            isMobile ? 24 : 16,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 2 : 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _copy(context),
          borderRadius: BorderRadius.circular(10),
          child: Ink(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 12 : 8,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: foreground.withValues(alpha: isMobile ? 0.06 : 0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: isMobile ? 64 : 72,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: foreground.withValues(alpha: 0.7),
                      fontSize: isMobile ? 12 : 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: foreground,
                      fontSize: isMobile ? 13 : 14,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                    softWrap: true,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.copy_rounded,
                  size: isMobile ? 20 : 16,
                  color: foreground.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
