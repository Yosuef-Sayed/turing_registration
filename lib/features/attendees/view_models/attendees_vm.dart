import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turing_registration/features/attendees/models/attendee_data_model.dart';

class AttendeesVM extends ChangeNotifier {
  static const _prefKey = 'scanned_attendees';

  List<AttendeeDataModel> _attendees = [];
  List<AttendeeDataModel> get attendees => List.unmodifiable(_attendees);

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefKey);
    if (raw != null) {
      final List<dynamic> decoded = jsonDecode(raw);
      _attendees = decoded
          .map((e) => AttendeeDataModel.fromJson(e as Map<String, dynamic>))
          .toList();
      notifyListeners();
    }
  }

  bool hasScanned(String ticketCode) {
    return _attendees.any((a) => a.ticketCode == ticketCode);
  }

  Future<void> addAttendee(AttendeeDataModel attendee) async {
    if (hasScanned(attendee.ticketCode)) return;
    _attendees.add(attendee);
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_attendees.map((a) => a.toJson()).toList());
    await prefs.setString(_prefKey, encoded);
  }
}
