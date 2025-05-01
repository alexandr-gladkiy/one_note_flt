import 'package:flutter/material.dart';
import 'package:one_note_flt/models/note_layer.dart';

class ImageLayerWidget extends StatelessWidget {
  final NoteLayer layer;
  final int index;
  final Function(int, NoteLayer) onUpdate;
  final Function(int) onRemove;

  const ImageLayerWidget({
    super.key,
    required this.layer,
    required this.index,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          Image.network(
            layer.imagePath!,
            width: layer.size.width,
            height: layer.size.height,
            fit: BoxFit.cover,
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => onRemove(index),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onPanUpdate: (details) {
                final newWidth = layer.size.width + details.delta.dx;
                final newHeight = layer.size.height + details.delta.dy;
                if (newWidth > 50 && newHeight > 50) {
                  onUpdate(
                    index,
                    layer.copyWith(
                      size: Size(newWidth, newHeight),
                    ),
                  );
                }
              },
              child: Container(
                width: 20,
                height: 20,
                color: Colors.blue.withOpacity(0.5),
                child: const Icon(Icons.drag_handle, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}