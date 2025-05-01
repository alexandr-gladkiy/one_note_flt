import 'package:flutter/material.dart';
import 'package:one_note_flt/widgets/color_picker_dialog.dart';

class FormattingToolbar extends StatelessWidget {
  final TextStyle textStyle;
  final Function(TextStyle) onTextStyleChanged;
  final Function(Color) onColorChanged;
  final Function(Color) onPageColorChanged;

  const FormattingToolbar({
    super.key,
    required this.textStyle,
    required this.onTextStyleChanged,
    required this.onColorChanged,
    required this.onPageColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      color: Colors.grey[200],
      child: Row(
        children: [
          DropdownButton<String>(
            value: _getFontSizeLabel(textStyle.fontSize ?? 16),
            items: ['Small', 'Normal', 'Large', 'Huge']
                .map((label) => DropdownMenuItem(
                      value: label,
                      child: Text(label),
                    ))
                .toList(),
            onChanged: (value) {
              double? fontSize;
              switch (value) {
                case 'Small':
                  fontSize = 12;
                  break;
                case 'Normal':
                  fontSize = 16;
                  break;
                case 'Large':
                  fontSize = 20;
                  break;
                case 'Huge':
                  fontSize = 24;
                  break;
              }
              if (fontSize != null) {
                onTextStyleChanged(textStyle.copyWith(fontSize: fontSize));
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_bold),
            color: textStyle.fontWeight == FontWeight.bold
                ? Colors.blue
                : Colors.black,
            onPressed: () {
              onTextStyleChanged(
                textStyle.copyWith(
                  fontWeight: textStyle.fontWeight == FontWeight.bold
                      ? FontWeight.normal
                      : FontWeight.bold,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_italic),
            color: textStyle.fontStyle == FontStyle.italic
                ? Colors.blue
                : Colors.black,
            onPressed: () {
              onTextStyleChanged(
                textStyle.copyWith(
                  fontStyle: textStyle.fontStyle == FontStyle.italic
                      ? FontStyle.normal
                      : FontStyle.italic,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_underline),
            color: textStyle.decoration == TextDecoration.underline
                ? Colors.blue
                : Colors.black,
            onPressed: () {
              onTextStyleChanged(
                textStyle.copyWith(
                  decoration: textStyle.decoration == TextDecoration.underline
                      ? null
                      : TextDecoration.underline,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_color_text),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ColorPickerDialog(
                  initialColor: textStyle.color ?? Colors.black,
                  onColorChanged: (color) {
                    onTextStyleChanged(textStyle.copyWith(color: color));
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ColorPickerDialog(
                  initialColor: Colors.white,
                  onColorChanged: onPageColorChanged,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getFontSizeLabel(double size) {
    if (size <= 12) return 'Small';
    if (size <= 16) return 'Normal';
    if (size <= 20) return 'Large';
    return 'Huge';
  }
}