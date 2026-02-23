import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ilia_contacts/core/models/contact_model.dart';
import 'package:ilia_contacts/core/repositories/contacts_repository.dart';
import 'package:ilia_contacts/core/utils/result.dart';
import 'package:ilia_contacts/features/contacts/contacts_list/contacts_list_page.dart';
import 'package:ilia_contacts/features/contacts/widgets/contact_list_item.dart';
import 'package:ilia_contacts/features/contacts/widgets/loading_list_component.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  late MockContactsRepository mockRepository;
  final getIt = GetIt.instance;

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
    await tester.pumpWidget(const MaterialApp(home: ContactsListPage()));
  }

  group('ContactsListPage', () {
    testWidgets('should show loading initially', (tester) async {
      // Arrange
      // Deliberately delay or just return empty for a moment if we want to catch loading?
      // Actually VM calls fetch immediately.
      when(() => mockRepository.fetchContacts()).thenAnswer((_) async {
        await Future.delayed(
          const Duration(milliseconds: 100),
        ); // Delay to see loading
        return const Result.ok([]);
      });

      // Act
      await makeSut(tester);
      await tester.pump(const Duration(milliseconds: 10)); // Pump a frame

      // Assert
      expect(find.byType(LoadingListComponent), findsOneWidget);
      await tester.pumpAndSettle(); // Finish
    });

    testWidgets('should show list of contacts when loaded', (tester) async {
      // Arrange
      final contacts = [
        ContactModel(
          id: '1',
          name: 'User 1',
          email: 'u1@test.com',
          phone: '111',
        ),
        ContactModel(
          id: '2',
          name: 'User 2',
          email: 'u2@test.com',
          phone: '222',
        ),
      ];
      when(
        () => mockRepository.fetchContacts(),
      ).thenAnswer((_) async => Result.ok(contacts));

      // Act
      await makeSut(tester);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ContactListItem), findsNWidgets(2));
      expect(find.text('User 1'), findsOneWidget);
    });

    testWidgets('should show failure message when fetch fails', (tester) async {
      // Arrange
      when(
        () => mockRepository.fetchContacts(),
      ).thenAnswer((_) async => Result.error(Exception('Failed')));

      // Act
      await makeSut(tester);
      await tester.pumpAndSettle(); // Wait for error state

      // Assert
      expect(find.text('error_message'), findsOneWidget); // Checks key
    });
  });
}
