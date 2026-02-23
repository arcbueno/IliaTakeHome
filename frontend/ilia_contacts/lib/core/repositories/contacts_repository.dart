import 'package:dio/dio.dart';
import 'package:ilia_contacts/core/error/email_exists_exception.dart';
import 'package:ilia_contacts/core/error/network_error_exception.dart';
import 'package:ilia_contacts/core/error/not_found_exception.dart';
import 'package:ilia_contacts/core/models/contact_model.dart';
import 'package:ilia_contacts/core/models/create_contact_dto.dart';
import 'package:ilia_contacts/core/utils/result.dart';
import 'package:logger/logger.dart';

abstract class ContactsRepository {
  Future<Result<List<ContactModel>>> fetchContacts();
  Future<Result<void>> addContact(CreateContactDto contact);
  Future<Result<void>> deleteContact(String contactId);
}

class ContactsRepositoryImpl implements ContactsRepository {
  final Dio _dio;
  final Logger _logger;

  static const String route = '/users';

  ContactsRepositoryImpl(this._dio, this._logger);

  @override
  Future<Result<void>> addContact(CreateContactDto contact) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      await _dio.post(route, data: contact.toMap());
      return const Result.ok(null);
    } catch (error, stacktrace) {
      _logger.e('Failed to add contact: $error', stackTrace: stacktrace);
      return _handlerError<void>(error);
    }
  }

  @override
  Future<Result<void>> deleteContact(String contactId) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      await _dio.delete('$route/$contactId');
      return const Result.ok(null);
    } catch (error, stacktrace) {
      _logger.e('Failed to delete contact: $error', stackTrace: stacktrace);
      return _handlerError<void>(error);
    }
  }

  @override
  Future<Result<List<ContactModel>>> fetchContacts() async {
    try {
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulate network delay
      final response = await _dio.get(route);
      final List data = response.data as List;
      final contacts = data.map((e) => ContactModel.fromMap(e)).toList();
      return Result.ok(contacts);
    } catch (error, stacktrace) {
      _logger.e('Failed to fetch contacts: $error', stackTrace: stacktrace);
      return _handlerError<List<ContactModel>>(error);
    }
  }

  Result<T> _handlerError<T>(dynamic error) {
    if (error is DioException) {
      if (error.response?.statusCode == 409) {
        return Result<T>.error(EmailExistsException());
      }
      if (error.response?.statusCode == 404) {
        return Result<T>.error(NotFoundException());
      }
      return Result<T>.error(
        NetworkErrorException(error.message ?? 'Unknown network error'),
      );
    }
    return Result<T>.error(Exception('An unexpected error occurred: $error'));
  }
}
