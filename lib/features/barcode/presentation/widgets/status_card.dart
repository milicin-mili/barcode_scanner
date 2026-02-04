import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.barcode,
    required this.apiBaseUrl,
    required this.loading,
  });

  final String? barcode;
  final String apiBaseUrl;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Статус сканирования', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Последний штрихкод: ${barcode ?? '—'}'),
            const SizedBox(height: 6),
            Text('API: $apiBaseUrl'),
            const SizedBox(height: 6),
            Text(loading ? 'Загрузка данных...' : 'Готов к сканированию'),
          ],
        ),
      ),
    );
  }
}
