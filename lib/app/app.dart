import 'package:flutter/material.dart';

import '../features/barcode/presentation/barcode_page.dart';
import 'theme.dart';

class BarcodeScannerApp extends StatelessWidget {
  const BarcodeScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Scanner',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const BarcodePage(),
    );
  }
}
