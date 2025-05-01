import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatelessWidget {
  final Color initialColor;
  final Function(Color) onColorChanged;

  const ColorPickerDialog({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    Color currentColor = initialColor;

    return AlertDialog(
      title: const Text('Выберите цвет'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: initialColor,
          onColorChanged: (color) {
            currentColor = color;
          },
          showLabel: true,
          pickerAreaHeightPercent: 0.8,
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Отмена'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            onColorChanged(currentColor);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}