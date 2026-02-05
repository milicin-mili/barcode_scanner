import 'package:flutter/material.dart';

import '../core/navigation/app_navigator.dart';
import '../features/barcode/presentation/barcode_page.dart';
import 'theme.dart';

class BarcodeScannerApp extends StatelessWidget {
  const BarcodeScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Scanner',
      debugShowCheckedModeBanner: false,
      navigatorKey: AppNavigator.key,
      theme: buildAppTheme(),
      home: const BarcodePage(),
    );
  }
}
