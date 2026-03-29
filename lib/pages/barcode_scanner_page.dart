import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testpro26/main.dart'; // AppColors

class BarcodeScannerPage extends StatefulWidget {
  final bool standalone;
  const BarcodeScannerPage({super.key, this.standalone = false});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage>
    with SingleTickerProviderStateMixin {
  late MobileScannerController _scannerController;
  late AnimationController _animationController;
  bool _isProcessing = false;
  bool _hasPermission = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    // Add supported formats: EAN-13, UPC-A, QR Code, Code 128
    _scannerController = MobileScannerController(
      formats: const [
        BarcodeFormat.ean13,
        BarcodeFormat.upcA,
        BarcodeFormat.qrCode,
        BarcodeFormat.code128,
      ],
      detectionSpeed: DetectionSpeed.normal,
    );
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      if (mounted) {
        setState(() {
          _hasPermission = true;
          _isInitializing = false;
        });
      }
    } else {
      final result = await Permission.camera.request();
      if (mounted) {
        setState(() {
          _hasPermission = result.isGranted;
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isInitializing = true;
    });
    final result = await Permission.camera.request();
    if (mounted) {
      setState(() {
        _hasPermission = result.isGranted;
        _isInitializing = false;
      });
    }
    if (result.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String code = barcodes.first.rawValue ?? '';
      if (code.isNotEmpty) {
        setState(() {
          _isProcessing = true;
        });

        // Show success briefly
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Product scanned'),
            backgroundColor: AppColors.success,
            duration: const Duration(milliseconds: 1500),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 800));

        if (!mounted) return;

        // Use GoRouter to pass scanned barcode to details screen
        context.push('/product/$code').then((_) {
          if (mounted) {
            setState(() {
              _isProcessing = false;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: widget.standalone
            ? AppBar(
                title: const Text('Scan Barcode'),
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
            : null,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 16),
              Text(
                'Initializing camera...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    if (!_hasPermission) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: widget.standalone
            ? AppBar(
                title: const Text('Scan Barcode'),
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
            : null,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  size: 64,
                  color: Colors.white54,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Camera Permission Required',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Camera access is required to scan products',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _requestPermission,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('Grant Permission'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: widget.standalone
          ? AppBar(
              title: const Text('Scan Barcode'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : null,
      body: Stack(
        children: [
          // Real Camera View from mobile_scanner
          MobileScanner(controller: _scannerController, onDetect: _onDetect),

          // Transparent overlay with border
          Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
          ),

          // Scanning Frame cut-out simulation
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 10000,
                          ),
                        ],
                      ),
                    ),
                    // Animated Line
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Positioned(
                          top: _animationController.value * 230 + 10,
                          left: 10,
                          right: 10,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.success.withOpacity(0.8),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                if (_isProcessing)
                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: AppColors.primary),
                        SizedBox(height: 8),
                        Text(
                          'Scanning...',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox(height: 24),

                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'Align barcode within the frame',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Supports: EAN-13, UPC-A, QR Code, Code 128',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
