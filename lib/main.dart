import 'package:flutter/material.dart';
import 'package:one_note_flt/models/note_page.dart';
import 'package:one_note_flt/models/note_layer.dart';
import 'package:one_note_flt/services/note_storage.dart';
import 'package:one_note_flt/widgets/layer_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialData = await NoteStorage.loadNotes();
  runApp(OneNoteCloneApp(initialData: initialData));
}

class OneNoteCloneApp extends StatelessWidget {
  final NotePage? initialData;

  const OneNoteCloneApp({super.key, this.initialData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneNote Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NoteEditorPage(initialData: initialData),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NoteEditorPage extends StatefulWidget {
  final NotePage? initialData;

  const NoteEditorPage({super.key, this.initialData});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late NotePage _notePage;
  final NoteStorage _storage = NoteStorage();
  Offset _nextLayerPosition = const Offset(100, 100);

  @override
  void initState() {
    super.initState();
    _notePage = widget.initialData ?? NotePage(
      pageColor: Colors.white,
      layers: [
        NoteLayer.text(
          position: const Offset(100, 100),
          size: const Size(300, 200),
          color: Colors.teal.shade100,
          text: 'Начните вводить текст здесь...',
        ),
      ],
    );
  }

  void _addNewTextLayer() {
    setState(() {
      _notePage = _notePage.copyWith(
        layers: [
          ..._notePage.layers,
          NoteLayer.text(
            position: _nextLayerPosition,
            size: const Size(300, 200),
            color: Colors.blue.shade100,
            text: 'Новый текстовый блок...',
          ),
        ],
      );
      _nextLayerPosition += const Offset(30, 30);
    });
    _saveNotes();
  }

  void _updateLayer(int index, NoteLayer newLayer) {
    setState(() {
      final newLayers = List<NoteLayer>.from(_notePage.layers);
      newLayers[index] = newLayer;
      _notePage = _notePage.copyWith(layers: newLayers);
    });
    _saveNotes();
  }

  void _removeLayer(int index) {
    setState(() {
      final newLayers = List<NoteLayer>.from(_notePage.layers);
      newLayers.removeAt(index);
      _notePage = _notePage.copyWith(layers: newLayers);
    });
    _saveNotes();
  }

  void _bringToFront(int index) {
    setState(() {
      final newLayers = List<NoteLayer>.from(_notePage.layers);
      final maxZIndex = newLayers.fold(0, (max, layer) => layer.zIndex > max ? layer.zIndex : max);
      newLayers[index] = newLayers[index].copyWith(zIndex: maxZIndex + 1);
      _notePage = _notePage.copyWith(layers: newLayers);
    });
    _saveNotes();
  }

  void _changePageColor(Color color) {
    setState(() {
      _notePage = _notePage.copyWith(pageColor: color);
    });
    _saveNotes();
  }

  Future<void> _saveNotes() async {
    await _storage.saveNotes(_notePage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OneNote Clone'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNotes,
            tooltip: 'Сохранить',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewTextLayer,
            tooltip: 'Добавить текстовый блок',
          ),
        ],
      ),
      body: Container(
        color: _notePage.pageColor,
        child: Stack(
          children: [
            for (int i = 0; i < _notePage.layers.length; i++)
              LayerWidget(
                key: ValueKey(_notePage.layers[i].id),
                layer: _notePage.layers[i],
                index: i,
                onUpdate: _updateLayer,
                onRemove: _removeLayer,
                onBringToFront: _bringToFront,
                onChangePageColor: _changePageColor,
              ),
          ],
        ),
      ),
    );
  }
}