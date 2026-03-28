// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:turing_registration/core/utils/constants/constants.dart';

enum ScanResultType { success, alreadyScanned, notFound, error, preview }

void showRegistrationResult(
  BuildContext context,
  ScanResultType type, {
  String? attendeeName,
  String? email,
  String? phoneNumber,
  String? ticketCode,
  String? scannedAt,
  String? errorMessage,
  VoidCallback? onDone,
  VoidCallback? onConfirm,
}) {
  Color accentColor;
  IconData icon;
  String title;
  Widget body;

  switch (type) {
    case ScanResultType.success:
      accentColor = kSuccessColor;
      icon = Icons.check_circle_rounded;
      title = 'Checked In!';
      body = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (attendeeName != null) ...[
            Text('Name', style: _labelStyle),
            Text(attendeeName, style: _valueStyle),
            const SizedBox(height: 12),
          ],
          if (email != null) ...[
            Text('Email', style: _labelStyle),
            Text(email, style: _valueStyle),
            const SizedBox(height: 12),
          ],
          if (phoneNumber != null) ...[
            Text('Phone Number', style: _labelStyle),
            Text(phoneNumber, style: _valueStyle),
            const SizedBox(height: 12),
          ],
          if (ticketCode != null) ...[
            Text('Ticket Code', style: _labelStyle),
            Text(ticketCode, style: _valueStyle),
          ],
        ],
      );
      break;

    case ScanResultType.preview:
      accentColor = const Color(0xff6366f1); // Indigo for preview
      icon = Icons.info_outline_rounded;
      title = 'Ticket Info';
      body = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (attendeeName != null) ...[
            Text('Name', style: _labelStyle),
            Text(attendeeName, style: _valueStyle),
            const SizedBox(height: 12),
          ],
          if (email != null) ...[
            Text('Email', style: _labelStyle),
            Text(email, style: _valueStyle),
            const SizedBox(height: 12),
          ],
          if (phoneNumber != null) ...[
            Text('Phone Number', style: _labelStyle),
            Text(phoneNumber, style: _valueStyle),
            const SizedBox(height: 12),
          ],
          if (ticketCode != null) ...[
            Text('Ticket Code', style: _labelStyle),
            Text(ticketCode, style: _valueStyle),
          ],
        ],
      );
      break;

    case ScanResultType.alreadyScanned:
      accentColor = kWarningColor;
      icon = Icons.warning_amber_rounded;
      title = 'Already Scanned';
      body = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('This ticket has already been checked in.', style: _valueStyle),
          if (scannedAt != null) ...[
            const SizedBox(height: 12),
            Text('Scanned at', style: _labelStyle),
            Text(_formatDateTime(scannedAt), style: _valueStyle),
          ],
        ],
      );
      break;

    case ScanResultType.notFound:
      accentColor = kErrorColor;
      icon = Icons.search_off_rounded;
      title = 'Ticket Not Found';
      body = Text(
        errorMessage ?? 'This ticket code does not exist in the system.',
        style: _valueStyle,
      );
      break;

    case ScanResultType.error:
      accentColor = kErrorColor;
      icon = Icons.error_outline_rounded;
      title = 'Error';
      body = Text(
        errorMessage ?? 'An unexpected error occurred.',
        style: _valueStyle,
      );
      break;
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.85),
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: accentColor.withOpacity(0.4), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon circle
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.15),
              ),
              child: Icon(icon, color: accentColor, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: accentColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            body,
            const SizedBox(height: 24),
            if (type == ScanResultType.preview) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xff94a3b8),
                        side: BorderSide(color: Colors.white.withOpacity(0.1)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        onDone?.call();
                      },
                      child: const Text('CANCEL'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        onConfirm?.call();
                      },
                      child: const Text('CONFIRM'),
                    ),
                  ),
                ],
              ),
            ] else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    onDone?.call();
                  },
                  child: const Text(
                    'DONE',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

String _formatDateTime(String iso) {
  try {
    final dt = DateTime.parse(iso).toLocal();
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day}/${dt.month}/${dt.year}  $hour:$min';
  } catch (_) {
    return iso;
  }
}

const _labelStyle = TextStyle(
  color: Color(0xff94a3b8),
  fontSize: 12,
  fontWeight: FontWeight.w500,
);

const _valueStyle = TextStyle(
  color: Colors.white,
  fontSize: 15,
  fontWeight: FontWeight.w600,
);
