import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ilia_contacts/core/models/create_contact_dto.dart';
import 'package:ilia_contacts/core/repositories/contacts_repository.dart';
import 'package:ilia_contacts/core/utils/result.dart';
import 'package:ilia_contacts/features/contacts/create_contact/create_contact_page.dart';
import 'package:ilia_contacts/features/contacts/widgets/create_contact_form.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

class FakeCreateContactDto extends Fake implements CreateContactDto {}

void main() {
  late MockContactsRepository mockRepository;
  final getIt = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(FakeCreateContactDto());
  });

  setUp(() {
    mockRepository = MockContactsRepository();
    if (getIt.isRegistered<ContactsRepository>()) {
      getIt.unregister<ContactsRepository>();
    }
    getIt.registerSingleton<ContactsRepository>(mockRepository);
  });

  tearDown(() {
    getIt.reset();
  });

  Future<void> makeSut(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CreateContactPage()));
  }

  group('CreateContactPage', () {
    testWidgets('should render form elements', (tester) async {
      // Arrange
      await makeSut(tester);

      // Assert
      expect(find.byType(CreateContactForm), findsOneWidget);
      expect(find.text('create_contact_title'), findsOneWidget);
    });

    testWidgets('should call repository when form is valid and submitted', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockRepository.addContact(any()),
      ).thenAnswer((_) async => const Result.ok(null));

      await makeSut(tester);
      await tester.pumpAndSettle();

      // Act
      // Assuming fields are text fields.
      // We need to identify fields by some property.
      // Since it's a custom form, we'll try to find by type TextFormField.
      // Order: Name, Email, Phone
      final fields = find.byType(TextFormField);
      if (fields.evaluate().length >= 2) {
        await tester.enterText(fields.at(0), 'John Doe');
        await tester.enterText(fields.at(1), 'john@example.com');
        await tester.pump();
      }

      // Tap submit button (usually ElevatedButton)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockRepository.addContact(any())).called(1);
    });
  });
}
