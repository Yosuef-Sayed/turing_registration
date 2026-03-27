import 'package:turing_registration/features/attendees/models/attendee_data_model.dart';

class TicketDataModel {
  final bool ok;
  final String? message;
  final String? error;
  final AttendeeDataModel? user;
  final String? ticketCode;

  final bool? found;
  final bool? scanned;
  final String? scannedAt;

  TicketDataModel({
    required this.ok,
    this.message,
    this.error,
    this.user,
    this.ticketCode,
    this.found,
    this.scanned,
    this.scannedAt,
  });

  factory TicketDataModel.fromJson(Map<String, dynamic> json) {
    final tCode = (json['ticketCode'] as String?) ?? '';
    return TicketDataModel(
      ok: json['ok'] ?? false,
      message: json['message'] as String?,
      error: json['error'] as String?,
      user: json['user'] != null
          ? AttendeeDataModel.fromUserJson(
              json['user'] as Map<String, dynamic>,
              tCode,
            )
          : null,
      ticketCode: tCode.isEmpty ? null : tCode,
      found: json['found'] as bool?,
      scanned: json['scanned'] as bool?,
      scannedAt: json['scannedAt'] as String?,
    );
  }
}
