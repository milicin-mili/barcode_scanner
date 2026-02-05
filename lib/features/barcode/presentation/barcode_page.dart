import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/barcode_providers.dart';
import 'widgets/error_card.dart';
import 'widgets/product_card.dart';
import 'widgets/status_card.dart';

class BarcodePage extends ConsumerWidget {
  const BarcodePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(barcodeControllerProvider);
    final config = ref.watch(appConfigProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Сканер штрихкодов',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StatusCard(
                barcode: state.lastBarcode,
                apiBaseUrl: config.apiBaseUrl,
                loading: state.isLoading,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () => ref
                        .read(barcodeControllerProvider.notifier)
                        .scan(),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Сканировать камерой'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () => ref
                        .read(barcodeControllerProvider.notifier)
                        .scan(
                          scanner: ref.read(mockBarcodeScannerProvider),
                        ),
                icon: const Icon(Icons.qr_code),
                label: const Text('Тестовый штрихкод'),
              ),
              const SizedBox(height: 20),
              if (state.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (state.errorMessage != null)
                ErrorCard(message: state.errorMessage!)
              else if (state.product != null)
                ProductCard(product: state.product!),
            ],
          ),
        ),
      ),
    );
  }
}
