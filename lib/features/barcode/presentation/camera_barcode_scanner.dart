import 'package:flutter/material.dart';

import '../../../core/navigation/app_navigator.dart';
import '../domain/services/barcode_scanner.dart';
import 'barcode_scan_page.dart';

class CameraBarcodeScanner implements BarcodeScanner {
  CameraBarcodeScanner({GlobalKey<NavigatorState>? navigatorKey})
      : _navigatorKey = navigatorKey ?? AppNavigator.key;

  final GlobalKey<NavigatorState> _navigatorKey;

  @override
  Future<String?> scan() async {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) {
      throw StateError('Навигация еще не инициализирована.');
    }

    final result = await navigator.push<String?>(
      MaterialPageRoute(
        builder: (_) => const BarcodeScanPage(),
        fullscreenDialog: true,
      ),
    );

    final value = result?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }
}
