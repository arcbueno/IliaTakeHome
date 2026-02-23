// ignore_for_file: public_member_api_docs, sort_constructors_first
class CreateContactDto {
  final String name;
  final String email;
  final String? phone;

  CreateContactDto({required this.name, required this.email, this.phone});

  factory CreateContactDto.empty() {
    return CreateContactDto(name: '', email: '');
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'phone': phone};
  }

  CreateContactDto copyWith({String? name, String? email, String? phone}) {
    return CreateContactDto(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
