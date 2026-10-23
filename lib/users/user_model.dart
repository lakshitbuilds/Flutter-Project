class AppUser {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String image;
  final String company;
  final int age;

  const AppUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.image,
    required this.company,
    required this.age,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final companyValue = json['company'];
    final companyMap = companyValue is Map<String, dynamic>
        ? companyValue
        : <String, dynamic>{};
    return AppUser(
      id: (json['id'] as num?)?.toInt() ?? 0,
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      company: companyMap['name']?.toString() ?? 'Not specified',
      age: (json['age'] as num?)?.toInt() ?? 0,
    );
  }
}
