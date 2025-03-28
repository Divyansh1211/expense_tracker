class UserData {
  final String? name;
  final String? email;

  UserData({this.name, this.email});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    final jsonMap = <String, dynamic>{};
    if (name != null) jsonMap['name'] = name;
    if (email != null) jsonMap['email'] = email;
    return jsonMap;
  }

  UserData copyWith({
    String? name,
    String? email,
  }) {
    return UserData(
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
