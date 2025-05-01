import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum LayerType { text, image }

class NoteLayer {
  final String id;
  final LayerType type;
  final Offset position;
  final Size size;
  final Color color;
  final String? text;
  final String? imagePath;
  final int zIndex;
  final TextEditingController? controller;
  final TextStyle textStyle;

  NoteLayer({
    required this.id,
    required this.type,
    required this.position,
    required this.size,
    required this.color,
    this.text,
    this.imagePath,
    required this.zIndex,
    this.controller,
    this.textStyle = const TextStyle(fontSize: 16),
  });

  factory NoteLayer.text({
    String? id,
    required Offset position,
    required Size size,
    required Color color,
    required String text,
    int? zIndex,
    TextStyle? textStyle,
  }) {
    final controller = TextEditingController(text: text);
    return NoteLayer(
      id: id ?? const Uuid().v4(),
      type: LayerType.text,
      position: position,
      size: size,
      color: color,
      text: text,
      zIndex: zIndex ?? 0,
      controller: controller,
      textStyle: textStyle ?? const TextStyle(fontSize: 16),
    );
  }

  factory NoteLayer.image({
    String? id,
    required Offset position,
    required Size size,
    required String imagePath,
    int? zIndex,
  }) {
    return NoteLayer(
      id: id ?? const Uuid().v4(),
      type: LayerType.image,
      position: position,
      size: size,
      color: Colors.transparent,
      imagePath: imagePath,
      zIndex: zIndex ?? 0,
    );
  }

  NoteLayer copyWith({
    Offset? position,
    Size? size,
    Color? color,
    String? text,
    String? imagePath,
    int? zIndex,
    TextStyle? textStyle,
  }) {
    return NoteLayer(
      id: id,
      type: type,
      position: position ?? this.position,
      size: size ?? this.size,
      color: color ?? this.color,
      text: text ?? this.text,
      imagePath: imagePath ?? this.imagePath,
      zIndex: zIndex ?? this.zIndex,
      controller: controller,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'position': {'x': position.dx, 'y': position.dy},
      'size': {'width': size.width, 'height': size.height},
      'color': color.value,
      'text': text,
      'imagePath': imagePath,
      'zIndex': zIndex,
      'textStyle': {
        'fontSize': textStyle.fontSize,
        'fontWeight': textStyle.fontWeight?.index,
        'fontStyle': textStyle.fontStyle?.index,
        'color': textStyle.color?.value,
      },
    };
  }

  factory NoteLayer.fromJson(Map<String, dynamic> json) {
    final type = LayerType.values.firstWhere(
      (e) => e.toString() == json['type'],
      orElse: () => LayerType.text,
    );

    final textStyle = TextStyle(
      fontSize: json['textStyle']?['fontSize']?.toDouble(),
      fontWeight: json['textStyle']?['fontWeight'] != null
          ? FontWeight.values[json['textStyle']['fontWeight']]
          : null,
      fontStyle: json['textStyle']?['fontStyle'] != null
          ? FontStyle.values[json['textStyle']['fontStyle']]
          : null,
      color: json['textStyle']?['color'] != null
          ? Color(json['textStyle']['color'])
          : null,
    );

    if (type == LayerType.text) {
      return NoteLayer.text(
        id: json['id'],
        position: Offset(
          json['position']['x'].toDouble(),
          json['position']['y'].toDouble(),
        ),
        size: Size(
          json['size']['width'].toDouble(),
          json['size']['height'].toDouble(),
        ),
        color: Color(json['color']),
        text: json['text'],
        zIndex: json['zIndex'],
        textStyle: textStyle,
      );
    } else {
      return NoteLayer.image(
        id: json['id'],
        position: Offset(
          json['position']['x'].toDouble(),
          json['position']['y'].toDouble(),
        ),
        size: Size(
          json['size']['width'].toDouble(),
          json['size']['height'].toDouble(),
        ),
        imagePath: json['imagePath'],
        zIndex: json['zIndex'],
      );
    }
  }
}