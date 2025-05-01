import 'package:flutter/material.dart';
import 'package:one_note_flt/models/note_layer.dart';
import 'package:one_note_flt/widgets/formatting_toolbar.dart';
import 'package:one_note_flt/widgets/color_picker_dialog.dart';

class TextLayerWidget extends StatefulWidget {
  final NoteLayer layer;
  final int index;
  final Function(int, NoteLayer) onUpdate;
  final Function(int) onRemove;
  final Function(Color) onChangePageColor;

  const TextLayerWidget({
    super.key,
    required this.layer,
    required this.index,
    required this.onUpdate,
    required this.onRemove,
    required this.onChangePageColor,
  });

  @override
  State<TextLayerWidget> createState() => _TextLayerWidgetState();
}

class _TextLayerWidgetState extends State<TextLayerWidget> {
  late TextEditingController _controller;
  bool _showToolbar = false;
  TextStyle _textStyle = const TextStyle(fontSize: 16);

  @override
  void initState() {
    super.initState();
    _controller = widget.layer.controller ?? TextEditingController();
    _textStyle = widget.layer.textStyle;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.layer.color,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (_showToolbar)
            FormattingToolbar(
              textStyle: _textStyle,
              onTextStyleChanged: (style) {
                setState(() {
                  _textStyle = style;
                });
                widget.onUpdate(
                  widget.index,
                  widget.layer.copyWith(textStyle: style),
                );
              },
              onColorChanged: (color) {
                widget.onUpdate(
                  widget.index,
                  widget.layer.copyWith(color: color),
                );
              },
              onPageColorChanged: widget.onChangePageColor,
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                maxLines: null,
                style: _textStyle,
                onChanged: (text) {
                  widget.onUpdate(
                    widget.index,
                    widget.layer.copyWith(text: text),
                  );
                },
                onTap: () {
                  setState(() {
                    _showToolbar = true;
                  });
                },
              ),
            ),
          ),
          _buildLayerControls(),
        ],
      ),
    );
  }

  Widget _buildLayerControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.color_lens, size: 18),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ColorPickerDialog(
                initialColor: widget.layer.color,
                onColorChanged: (color) {
                  widget.onUpdate(
                    widget.index,
                    widget.layer.copyWith(color: color),
                  );
                },
              ),
            );
          },
        ),
        GestureDetector(
          onPanUpdate: (details) {
            final newWidth = widget.layer.size.width + details.delta.dx;
            final newHeight = widget.layer.size.height + details.delta.dy;
            if (newWidth > 100 && newHeight > 50) {
              widget.onUpdate(
                widget.index,
                widget.layer.copyWith(
                  size: Size(newWidth, newHeight),
                ),
              );
            }
          },
          child: Container(
            width: 20,
            height: 20,
            color: Colors.blue.withOpacity(0.5),
            child: const Icon(Icons.drag_handle, size: 16),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: () => widget.onRemove(widget.index),
        ),
      ],
    );
  }
}