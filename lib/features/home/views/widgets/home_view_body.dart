// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:turing_registration/core/utils/functions/snackbar.dart';
import 'package:turing_registration/features/home/models/ticket_data_model.dart';
import 'package:turing_registration/features/home/view_models/ticket_scanner_vm.dart';
import 'package:turing_registration/features/home/views/widgets/attendees_screen_button.dart';
import 'package:turing_registration/features/home/views/widgets/manual_code_input.dart';
import 'package:turing_registration/features/home/views/widgets/scanner_controls.dart';
import 'package:turing_registration/features/home/views/widgets/scanner_overlay.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final MobileScannerController controller = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _performRegistration(String code) async {
    if (_isProcessing) return;

    final trimmed = code.trim();
    if (trimmed.isEmpty) return;

    setState(() => _isProcessing = true);
    // Explicitly stop scanning while processing/dialog is open
    await controller.stop();
    
    HapticFeedback.vibrate();
    log('Fetching status for: $trimmed');

    try {
      final scannerVM = context.read<TicketScannerVM>();
      // Step 1: Check status via GET
      final TicketDataModel initialResult = await scannerVM.checkStatus(trimmed);

      if (!mounted) return;

      if (!initialResult.ok) {
        // Already scanned - show warning immediately
        showRegistrationResult(
          context,
          ScanResultType.alreadyScanned,
          scannedAt: initialResult.scannedAt,
          onDone: () async {
            setState(() => _isProcessing = false);
            await controller.start();
          },
        );
        return;
      }

      // Step 2: Show preview dialog
      showRegistrationResult(
        context,
        ScanResultType.preview,
        attendeeName: initialResult.user?.name,
        email: initialResult.user?.email,
        phoneNumber: initialResult.user?.phone,
        ticketCode: initialResult.ticketCode,
        onDone: () async {
          setState(() => _isProcessing = false);
          await controller.start();
        },
        onConfirm: () async {
          // Step 3: Mark as scanned via POST
          try {
            final result = await scannerVM.checkIn(trimmed);
            if (!mounted) return;
            
            if (result.ok) {
              showRegistrationResult(
                context,
                ScanResultType.success,
                attendeeName: result.user?.name,
                email: result.user?.email,
                phoneNumber: result.user?.phone,
                ticketCode: result.ticketCode,
                onDone: () async {
                  setState(() => _isProcessing = false);
                  await controller.start();
                },
              );
            } else {
              // Handle case where it was scanned while in preview
              showRegistrationResult(
                context,
                ScanResultType.alreadyScanned,
                scannedAt: result.scannedAt,
                onDone: () async {
                  setState(() => _isProcessing = false);
                  await controller.start();
                },
              );
            }
          } catch (e) {
            if (!mounted) return;
            showRegistrationResult(
              context,
              ScanResultType.error,
              errorMessage: e.toString().replaceFirst('Exception: ', ''),
              onDone: () async {
                setState(() => _isProcessing = false);
                await controller.start();
              },
            );
          }
        },
      );
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      final isNotFound =
          (message.toLowerCase().contains('not found') ||
              message.toLowerCase().contains('404')) &&
          !message.toLowerCase().contains('application not found');

      showRegistrationResult(
        context,
        isNotFound ? ScanResultType.notFound : ScanResultType.error,
        errorMessage: message,
        onDone: () async {
          setState(() => _isProcessing = false);
          await controller.start();
        },
      );
    }
  }

  void _handleDetection(BarcodeCapture capture) {
    if (_isProcessing || !controller.value.isRunning) return;
    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final code = barcodes.first.displayValue ?? '';
      if (code.isNotEmpty) {
        _performRegistration(code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const double scanWindowSize = 250.0;
    final double halfScreenHeight = MediaQuery.of(context).size.height / 2;
    const double holeSize = 250.0;
    const double gap = 20.0;

    final scanWindow = Rect.fromCenter(
      center: Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
      ),
      width: scanWindowSize,
      height: scanWindowSize,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: controller,
          scanWindow: scanWindow,
          onDetect: _handleDetection,
          onDetectError: (Object error, StackTrace stackTrace) {
            log(error.toString());
            String errorMessage = 'Scanner Error';
            if (error is MobileScannerException) {
              errorMessage =
                  error.errorDetails?.message ?? error.errorCode.name;
            }
            if (mounted) {
              showRegistrationResult(
                context,
                ScanResultType.error,
                errorMessage: errorMessage,
              );
            }
          },
        ),
        ScannerOverlay(scanWindow: scanWindow),
        SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: halfScreenHeight - (holeSize / 2) - gap - 150,
                left: 0,
                right: 0,
                child: const Text(
                  'Scan Ticket or Enter Code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                top: halfScreenHeight - (holeSize / 2) - gap - 100,
                left: 0,
                right: 0,
                child: ManualCodeInput(onSubmit: _performRegistration),
              ),
              if (_isProcessing)
                Center(
                  child: SizedBox(
                    width: holeSize,
                    height: holeSize,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),
              Positioned(
                top: halfScreenHeight + (holeSize / 3) + gap,
                left: 0,
                right: 0,
                child: ScannerControls(controller: controller),
              ),
              Align(
                alignment: const Alignment(0, 0.85),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Center the QR code within the frame',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const AttendeesScreenButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
