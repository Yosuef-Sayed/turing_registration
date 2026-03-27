// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ScannerOverlay extends StatelessWidget {
  final Rect scanWindow;
  const ScannerOverlay({super.key, required this.scanWindow});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: scanWindow.width,
                  height: scanWindow.height,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            width: scanWindow.width,
            height: scanWindow.height,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: const _ScannerBrackets(),
          ),
        ),
      ],
    );
  }
}

class _ScannerBrackets extends StatelessWidget {
  const _ScannerBrackets();

  @override
  Widget build(BuildContext context) {
    const double bWidth = 30.0;
    const double bHeight = 30.0;
    const double bThickness = 3.0;
    const Color bColor = Colors.white;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: Container(width: bWidth, height: bThickness, color: bColor),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(width: bThickness, height: bHeight, color: bColor),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(width: bWidth, height: bThickness, color: bColor),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(width: bThickness, height: bHeight, color: bColor),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(width: bWidth, height: bThickness, color: bColor),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(width: bThickness, height: bHeight, color: bColor),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(width: bWidth, height: bThickness, color: bColor),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(width: bThickness, height: bHeight, color: bColor),
        ),
      ],
    );
  }
}
