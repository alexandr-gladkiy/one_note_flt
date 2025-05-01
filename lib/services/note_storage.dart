import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_page.dart';
import 'dart:convert';

class NoteStorage {
  static const String _storageKey = 'note_data';

  Future<void> saveNotes(NotePage notePage) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, notePage.toJson().toString());
  }

  static Future<NotePage?> loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        final jsonData = json.decode(jsonString) as Map<String, dynamic>;
        return NotePage.fromJson(jsonData);
      }
    } catch (e) {
      debugPrint('Error loading notes: $e');
    }
    return null;
  }
}