import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:turing_registration/features/attendees/models/attendee_data_model.dart';
import 'package:turing_registration/features/attendees/view_models/attendees_vm.dart';
import 'package:turing_registration/features/home/models/ticket_data_model.dart';
import 'package:turing_registration/core/utils/constants/constants.dart';

class TicketScannerVM extends ChangeNotifier {
  final http.Client _client;
  final AttendeesVM _attendeesVM;

  TicketScannerVM(this._client, this._attendeesVM);

  Future<TicketDataModel> checkIn(String code) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/ticket/check'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'code': code}),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      final ticketCode = json['ticketCode'] as String? ?? code;
      if (json['user'] != null) {
        final attendee = AttendeeDataModel.fromUserJson(
          json['user'] as Map<String, dynamic>,
          ticketCode,
        );
        await _attendeesVM.addAttendee(attendee);
      }
      return TicketDataModel.fromJson(json);
    } else if (response.statusCode == 409) {
      return TicketDataModel.fromJson(json);
    } else if (response.statusCode == 404) {
      final errorMessage =
          json['error'] ?? json['message'] ?? 'Ticket not found';
      throw Exception(errorMessage);
    } else {
      final errorMessage =
          json['error'] ??
          json['message'] ??
          'Server error (${response.statusCode})';
      throw Exception(errorMessage);
    }
  }

  Future<TicketDataModel> checkStatus(String code) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/api/ticket/check?code=$code'),
    );
    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return TicketDataModel.fromJson(json);
    } else if (response.statusCode == 404) {
      throw Exception(json['error'] ?? 'Ticket not found');
    } else {
      throw Exception(json['error'] ?? 'Server error (${response.statusCode})');
    }
  }
}
