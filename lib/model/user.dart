class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String jobPosition;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.jobPosition,
  });

  static User empty() => User(
        id: "",
        name: "Unknown",
        email: "",
        password: "",
        role: "user",
        jobPosition: "Employee",
      );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? "",
      name: json['name'] ?? "Unknown",
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      role: json['role'] ?? "user",
      jobPosition: json['jobPosition'] ?? "Employee",
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        'jobPosition': jobPosition,
      };
}
