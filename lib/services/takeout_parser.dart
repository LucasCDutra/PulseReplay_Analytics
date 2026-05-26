import 'dart:convert';

import '../models/history_entry.dart';

class TakeoutParser {
  static List<HistoryEntry> parse(String source) {
    final decoded = jsonDecode(source);
    final list = switch (decoded) {
      List<dynamic> value => value,
      Map<String, dynamic> value when value['items'] is List =>
        value['items'] as List<dynamic>,
      Map<String, dynamic> value when value['history'] is List =>
        value['history'] as List<dynamic>,
      _ => throw const FormatException(
          'Arquivo JSON inválido para histórico do YouTube.'),
    };

    return list
        .whereType<Map<String, dynamic>>()
        .map(HistoryEntry.fromJson)
        .where((entry) => entry.time.millisecondsSinceEpoch > 0)
        .toList()
      ..sort((a, b) => b.time.compareTo(a.time));
  }
}
