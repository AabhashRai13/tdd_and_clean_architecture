import 'dart:convert';
import 'package:tdd_and_clean_architecture/core/errors/exceptions.dart';
import 'package:tdd_and_clean_architecture/core/utils/constants.dart';
import 'package:tdd_and_clean_architecture/core/utils/typedef.dart';
import 'package:tdd_and_clean_architecture/features/authentication/data/models/user_model.dart';
import 'package:tdd_and_clean_architecture/features/authentication/domain/enitites/user.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<User>> getUsers();
}

class AuthenticationRemoteDataSourceImplementation
    implements AuthenticationRemoteDataSource {
  const AuthenticationRemoteDataSourceImplementation(this._client);

  final http.Client _client;

  @override
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    // 1. CHECK to make sure that it returns the rught data when the response
    // code is 200 or the proper response code
    // 2. CHECK to make sure that it throws an "CUSTOM EXCEPTION"
    // exception when the response code
    try {
      final response = await _client.post(
        Uri.parse('${kBaseUrl}users'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'createdAt': createdAt,
          'name': name,
          'avatar': avatar,
        }),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<List<User>> getUsers() async {
    try {
      final response = await _client.get(
        Uri.https(kBaseUrlWithoutHttps, "/test-api/users"),
      );
      if (response.statusCode != 200) {
        throw ApiException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map((userData) => UserModel.fromJson(userData))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }
}
