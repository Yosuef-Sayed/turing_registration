class AttendeeDataModel {
  final String name;
  final String email;
  final String ticketCode;

  AttendeeDataModel({
    required this.name,
    required this.email,
    required this.ticketCode,
  });

  factory AttendeeDataModel.fromUserJson(
    Map<String, dynamic> userJson,
    String ticketCode,
  ) {
    return AttendeeDataModel(
      name: (userJson['name'] as String?) ?? 'Unknown',
      email: (userJson['email'] as String?) ?? 'No Email',
      ticketCode: ticketCode,
    );
  }

  factory AttendeeDataModel.fromJson(Map<String, dynamic> json) {
    return AttendeeDataModel(
      name: (json['name'] as String?) ?? 'Unknown',
      email: (json['email'] as String?) ?? 'No Email',
      ticketCode: (json['ticketCode'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'ticketCode': ticketCode,
  };
}
