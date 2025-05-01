import 'package:flutter/material.dart';
import 'package:one_note_flt/models/note_layer.dart';
import 'package:one_note_flt/widgets/text_layer.dart';
import 'package:one_note_flt/widgets/image_layer.dart';

class LayerWidget extends StatelessWidget {
  final NoteLayer layer;
  final int index;
  final Function(int, NoteLayer) onUpdate;
  final Function(int) onRemove;
  final Function(int) onBringToFront;
  final Function(Color) onChangePageColor;

  const LayerWidget({
    super.key,
    required this.layer,
    required this.index,
    required this.onUpdate,
    required this.onRemove,
    required this.onBringToFront,
    required this.onChangePageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: layer.position.dx,
      top: layer.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          onUpdate(
            index,
            layer.copyWith(
              position: layer.position + details.delta,
            ),
          );
        },
        onTap: () => onBringToFront(index),
        child: SizedBox(
          width: layer.size.width,
          height: layer.size.height,
          child: layer.type == LayerType.text
              ? TextLayerWidget(
                  layer: layer,
                  index: index,
                  onUpdate: onUpdate,
                  onRemove: onRemove,
                  onChangePageColor: onChangePageColor,
                )
              : ImageLayerWidget(
                  layer: layer,
                  index: index,
                  onUpdate: onUpdate,
                  onRemove: onRemove,
                ),
        ),
      ),
    );
  }
}