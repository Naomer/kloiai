import 'package:flutter/foundation.dart';

class HistoryEntry {
  final String prompt;
  final String reply;
  final DateTime timestamp;
  final String? modelId;

  const HistoryEntry({
    required this.prompt,
    required this.reply,
    required this.timestamp,
    this.modelId,
  });
}

class HistoryStore extends ChangeNotifier {
  HistoryStore._();
  static final HistoryStore instance = HistoryStore._();

  final List<HistoryEntry> _entries = [];

  List<HistoryEntry> get entries => List.unmodifiable(_entries);

  void addEntry(HistoryEntry entry) {
    _entries.insert(0, entry);
    notifyListeners();
  }

  void clear() {
    _entries.clear();
    notifyListeners();
  }
}

