class UserData {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final bool? isLoading;

  UserData(
      {this.id, this.name, this.email, this.password, this.isLoading = false});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    final jsonMap = <String, dynamic>{};
    if (id != null) jsonMap['id'] = id;
    if (name != null) jsonMap['name'] = name;
    if (email != null) jsonMap['email'] = email;
    if (password != null) jsonMap['password'] = password;
    return jsonMap;
  }

  UserData copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    bool? isLoading,
  }) {
    return UserData(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
