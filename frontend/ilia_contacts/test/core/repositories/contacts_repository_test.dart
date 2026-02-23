import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ilia_contacts/core/error/email_exists_exception.dart';
import 'package:ilia_contacts/core/error/network_error_exception.dart';
import 'package:ilia_contacts/core/models/create_contact_dto.dart';
import 'package:ilia_contacts/core/repositories/contacts_repository.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockLogger extends Mock implements Logger {}

void main() {
  late MockDio mockDio;
  late MockLogger mockLogger;
  late ContactsRepositoryImpl sut;

  setUp(() {
    mockDio = MockDio();
    mockLogger = MockLogger();
    sut = ContactsRepositoryImpl(mockDio, mockLogger);
  });

  group('ContactsRepository', () {
    const route = '/users';

    group('fetchContacts', () {
      test('should return list of contacts when successful', () async {
        // Arrange
        final responseData = [
          {
            'id': '1',
            'name': 'Test User',
            'email': 'test@test.com',
            'phone': '123456789',
          },
        ];
        when(() => mockDio.get(route)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: route),
            data: responseData,
            statusCode: 200,
          ),
        );

        // Act
        final result = await sut.fetchContacts();

        // Assert
        expect(result.isOk, true);
        result.fold(
          onOk: (contacts) {
            expect(contacts.length, 1);
            expect(contacts.first.id, '1');
            expect(contacts.first.name, 'Test User');
          },
          onError: (_) => fail('Should involve success'),
        );
        verify(() => mockDio.get(route)).called(1);
      });

      test('should return error when fetch fails', () async {
        // Arrange
        when(() => mockDio.get(route)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: route),
            message: 'Network error',
          ),
        );

        // Act
        final result = await sut.fetchContacts();

        // Assert
        expect(result.isError, true);
        result.fold(
          onOk: (_) => fail('Should be error'),
          onError: (error) => expect(error, isA<NetworkErrorException>()),
        );
      });
    });

    group('addContact', () {
      final newContact = CreateContactDto(
        name: 'New User',
        email: 'new@test.com',
        phone: '987654321',
      );

      test('should call post and return success', () async {
        // Arrange
        when(() => mockDio.post(route, data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: route),
            statusCode: 201,
          ),
        );

        // Act
        final result = await sut.addContact(newContact);

        // Assert
        expect(result.isOk, true);
        verify(() => mockDio.post(route, data: newContact.toMap())).called(1);
      });

      test('should return EmailExistsException on 409 conflict', () async {
        // Arrange
        when(() => mockDio.post(route, data: any(named: 'data'))).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: route),
            response: Response(
              requestOptions: RequestOptions(path: route),
              statusCode: 409,
            ),
          ),
        );

        // Act
        final result = await sut.addContact(newContact);

        // Assert
        result.fold(
          onOk: (_) => fail('Should be error'),
          onError: (error) => expect(error, isA<EmailExistsException>()),
        );
      });
    });

    group('deleteContact', () {
      const contactId = '123';

      test('should call delete and return success', () async {
        // Arrange
        when(() => mockDio.delete('$route/$contactId')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '$route/$contactId'),
            statusCode: 200,
          ),
        );

        // Act
        final result = await sut.deleteContact(contactId);

        // Assert
        expect(result.isOk, true);
        verify(() => mockDio.delete('$route/$contactId')).called(1);
      });

      test('should return error when delete fails', () async {
        // Arrange
        when(() => mockDio.delete('$route/$contactId')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '$route/$contactId'),
            message: 'Error',
          ),
        );

        // Act
        final result = await sut.deleteContact(contactId);

        // Assert
        expect(result.isError, true);
      });
    });
  });
}
