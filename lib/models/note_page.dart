import 'package:flutter/material.dart';
import 'note_layer.dart';

class NotePage {
  final Color pageColor;
  final List<NoteLayer> layers;

  NotePage({
    required this.pageColor,
    required this.layers,
  });

  NotePage copyWith({
    Color? pageColor,
    List<NoteLayer>? layers,
  }) {
    return NotePage(
      pageColor: pageColor ?? this.pageColor,
      layers: layers ?? this.layers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageColor': pageColor.value,
      'layers': layers.map((layer) => layer.toJson()).toList(),
    };
  }

  factory NotePage.fromJson(Map<String, dynamic> json) {
    return NotePage(
      pageColor: Color(json['pageColor']),
      layers: (json['layers'] as List)
          .map((layerJson) => NoteLayer.fromJson(layerJson))
          .toList(),
    );
  }
}