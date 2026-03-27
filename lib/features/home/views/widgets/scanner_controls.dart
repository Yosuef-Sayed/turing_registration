// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerControls extends StatelessWidget {
  final MobileScannerController controller;
  const ScannerControls({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ScannerControlButton(
          onTap: () => controller.toggleTorch(),
          child: ValueListenableBuilder<MobileScannerState>(
            valueListenable: controller,
            builder: (context, state, child) {
              return Icon(
                state.torchState == TorchState.on
                    ? Icons.flash_on
                    : Icons.flash_off,
                color: Colors.white,
              );
            },
          ),
        ),
        const SizedBox(width: 40),
        _ScannerControlButton(
          onTap: () => controller.switchCamera(),
          child: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white),
        ),
      ],
    );
  }
}

class _ScannerControlButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const _ScannerControlButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: IconButton(icon: child, onPressed: onTap),
    );
  }
}
