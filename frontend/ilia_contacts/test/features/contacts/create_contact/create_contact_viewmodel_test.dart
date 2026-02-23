import 'package:flutter_test/flutter_test.dart';
import 'package:ilia_contacts/core/models/create_contact_dto.dart';
import 'package:ilia_contacts/core/repositories/contacts_repository.dart';
import 'package:ilia_contacts/core/utils/result.dart';
import 'package:ilia_contacts/features/contacts/create_contact/create_contact_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

// Since CreateContactDto uses value equality, we might need a Fake if mocktail complains,
// but for simple DTOs usually 'any()' is enough if we register fallback.
class FakeCreateContactDto extends Fake implements CreateContactDto {}

void main() {
  late MockContactsRepository mockRepository;
  late CreateContactViewmodel sut;

  setUpAll(() {
    registerFallbackValue(FakeCreateContactDto());
  });

  setUp(() {
    mockRepository = MockContactsRepository();
    sut = CreateContactViewmodel(mockRepository);
  });

  group('CreateContactViewmodel', () {
    test('should set name correctly', () {
      // Act
      sut.name = 'John';
      // Assert
      expect(sut.contact.name, 'John');
    });

    test('should validate valid email', () {
      // Act
      final result = sut.validateEmail('test@example.com');
      // Assert
      expect(result, null);
    });

    test('should return error for invalid email', () {
      // Act
      final result = sut.validateEmail('invalid-email');
      // Assert
      expect(result, 'Enter a valid email'); // Assuming the string from VM
    });

    test('should call repository.addContact when executed', () async {
      // Arrange
      when(
        () => mockRepository.addContact(any()),
      ).thenAnswer((_) async => const Result.ok(null));
      sut.name = 'Test';
      sut.email = 'test@test.com';

      // Act
      await sut.createContact();

      // Assert
      verify(() => mockRepository.addContact(any())).called(1);
    });
  });
}
