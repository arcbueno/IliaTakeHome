class ContactModel {
  final String name;
  final String email;
  final String? phone;

  String get initials => name.isNotEmpty
      ? name.trim().split(' ').map((e) => e[0]).take(2).join()
      : '';

  ContactModel({required this.name, required this.email, required this.phone});

  ContactModel copyWith({String? name, String? email, String? phone}) {
    return ContactModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'email': email, 'phone': phone};
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String?,
    );
  }

  @override
  String toString() =>
      'ContactModel(name: $name, email: $email, phone: $phone)';

  @override
  bool operator ==(covariant ContactModel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.email == email && other.phone == phone;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ phone.hashCode;
}
