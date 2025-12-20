import 'package:flutter/material.dart';

import '../../data/history_store.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => HistoryStore.instance.clear(),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: HistoryStore.instance,
        builder: (context, _) {
          final entries = HistoryStore.instance.entries;
          if (entries.isEmpty) {
            return const Center(child: Text('No history yet'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final e = entries[index];
              return Card(
                child: ListTile(
                  title: Text(e.prompt),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(e.reply),
                      const SizedBox(height: 6),
                      Text(
                        _formatTimestamp(e.timestamp, e.modelId),
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime ts, String? modelId) {
    final d = '${ts.year.toString().padLeft(4, '0')}-'
        '${ts.month.toString().padLeft(2, '0')}-'
        '${ts.day.toString().padLeft(2, '0')} '
        '${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}';
    if (modelId == null || modelId.isEmpty) return d;
    return '$d · $modelId';
  }
}

