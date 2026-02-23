import 'package:flutter_test/flutter_test.dart';
import 'package:ilia_contacts/core/models/contact_model.dart';
import 'package:ilia_contacts/core/repositories/contacts_repository.dart';
import 'package:ilia_contacts/core/utils/result.dart';
import 'package:ilia_contacts/features/contacts/contacts_list/contacts_list_state.dart';
import 'package:ilia_contacts/features/contacts/contacts_list/contacts_list_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  late MockContactsRepository mockRepository;
  late ContactsListViewmodel sut;

  setUp(() {
    mockRepository = MockContactsRepository();
    // fetchContacts is called in constructor, so we need to mock it before
    when(
      () => mockRepository.fetchContacts(),
    ).thenAnswer((_) async => const Result.ok([]));
  });

  group('ContactsListViewmodel', () {
    test('should initialize with loading state and fetch contacts', () async {
      // Arrange
      // (Mock setup in setUp)

      // Act
      sut = ContactsListViewmodel(mockRepository);

      // Assert
      expect(sut.state.value, isA<ContactsListLoading>());
      await Future.delayed(Duration.zero); // Wait for async in constructor
      verify(() => mockRepository.fetchContacts()).called(1);
    });

    test('should update state to loaded when fetch is successful', () async {
      // Arrange
      final contacts = [
        ContactModel(
          id: '1',
          name: 'Test',
          email: 'test@test.com',
          phone: '123',
        ),
      ];
      when(
        () => mockRepository.fetchContacts(),
      ).thenAnswer((_) async => Result.ok(contacts));

      // Act
      sut = ContactsListViewmodel(mockRepository);
      await Future.delayed(Duration.zero);

      // Assert
      expect(sut.state.value, isA<ContactsListLoaded>());
      final loadedState = sut.state.value as ContactsListLoaded;
      expect(loadedState.contacts, contacts);
    });

    test('should update state to error when fetch fails', () async {
      // Arrange
      when(
        () => mockRepository.fetchContacts(),
      ).thenAnswer((_) async => Result.error(Exception('Error')));

      // Act
      sut = ContactsListViewmodel(mockRepository);
      await Future.delayed(Duration.zero);

      // Assert
      expect(sut.state.value, isA<ContactsListError>());
    });

    test('should reload contacts after successful deletion', () async {
      // Arrange
      sut = ContactsListViewmodel(mockRepository);
      when(
        () => mockRepository.deleteContact('1'),
      ).thenAnswer((_) async => const Result.ok(null));
      // Ensure fetch is mocked for the subsequent call
      when(
        () => mockRepository.fetchContacts(),
      ).thenAnswer((_) async => const Result.ok([]));

      // Act
      await sut.deleteContact('1');

      // Assert
      verify(() => mockRepository.deleteContact('1')).called(1);
      verify(
        () => mockRepository.fetchContacts(),
      ).called(2); // 1 (init) + 1 (after delete)
    });
  });
}
