import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class BarcodeScanPage extends StatefulWidget {
  const BarcodeScanPage({super.key});

  @override
  State<BarcodeScanPage> createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends State<BarcodeScanPage>
    with WidgetsBindingObserver {
  late final MobileScannerController _controller;
  bool _isHandlingResult = false;
  bool _permissionGranted = false;
  bool _permissionPermanentlyDenied = false;
  bool _isRequestingPermission = true;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
    WidgetsBinding.instance.addObserver(this);
    _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.status;
    PermissionStatus result = status;
    if (!status.isGranted) {
      result = await Permission.camera.request();
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _permissionGranted = result.isGranted;
      _permissionPermanentlyDenied = result.isPermanentlyDenied;
      _isRequestingPermission = false;
    });
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_permissionGranted || !_controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.resumed) {
      _controller.start();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller.stop();
    }
  }

  void _handleDetect(BarcodeCapture capture) {
    if (_isHandlingResult || !mounted) {
      return;
    }
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue?.trim();
      if (value != null && value.isNotEmpty) {
        _isHandlingResult = true;
        Navigator.of(context).pop(value);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сканирование'),
      ),
      body: _isRequestingPermission
          ? const Center(child: CircularProgressIndicator())
          : _permissionGranted
              ? Stack(
                  children: [
                    MobileScanner(
                      controller: _controller,
                      onDetect: _handleDetect,
                      errorBuilder: (context, error) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              error.errorCode ==
                                      MobileScannerErrorCode.permissionDenied
                                  ? 'Нужен доступ к камере для сканирования.'
                                  : 'Не удалось запустить камеру.\n'
                                      'Проверьте разрешения и попробуйте снова.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SafeArea(
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            'Наведите камеру на штрихкод',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Для сканирования нужен доступ к камере.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        if (_permissionPermanentlyDenied)
                          ElevatedButton.icon(
                            onPressed: _openAppSettings,
                            icon: const Icon(Icons.settings),
                            label: const Text('Открыть настройки'),
                          )
                        else
                          ElevatedButton.icon(
                            onPressed: _requestCameraPermission,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Разрешить доступ'),
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
