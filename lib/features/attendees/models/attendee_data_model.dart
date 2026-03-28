class AttendeeDataModel {
  final String name;
  final String email;
  final String? phone;
  final String ticketCode;

  AttendeeDataModel({
    required this.name,
    required this.email,
    this.phone,
    required this.ticketCode,
  });

  factory AttendeeDataModel.fromUserJson(
    Map<String, dynamic> userJson,
    String ticketCode,
  ) {
    return AttendeeDataModel(
      name: (userJson['name'] as String?) ?? 'Unknown',
      email: (userJson['email'] as String?) ?? 'No Email',
      phone: userJson['phone'] as String?,
      ticketCode: ticketCode,
    );
  }

  factory AttendeeDataModel.fromJson(Map<String, dynamic> json) {
    return AttendeeDataModel(
      name: (json['name'] as String?) ?? 'Unknown',
      email: (json['email'] as String?) ?? 'No Email',
      phone: json['phone'] as String?,
      ticketCode: (json['ticketCode'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'ticketCode': ticketCode,
  };
}
