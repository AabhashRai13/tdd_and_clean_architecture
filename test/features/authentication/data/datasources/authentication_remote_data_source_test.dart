import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_and_clean_architecture/core/errors/exceptions.dart';
import 'package:tdd_and_clean_architecture/core/utils/constants.dart';
import 'package:tdd_and_clean_architecture/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_and_clean_architecture/features/authentication/data/models/user_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthenticationRemoteDataSourceImplementation(client);
    registerFallbackValue(Uri());
  });
  const createdAt = "whatever.createdAt";
  const name = "whatever.name";
  const avatar = "whatever.avatar";
  group('create user', () {
    test('should return null when the response code is 200 or 201', () async {
      // Arrange
      when(() => client.post(
                any(),
                headers: any(named: 'headers'),
                body: any(named: 'body'),
              ))
          .thenAnswer(
              (_) async => http.Response('User created Successfuly', 200));
      // Act
      final methodCall = remoteDataSource.createUser;
      // Assert
      expect(
          methodCall(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          ),
          completes);
      verify(() => client.post(
            Uri.parse('${kBaseUrl}users'),
            headers: {'Content-Type': 'application/json'},
            body: any(named: 'body'),
          )).called(1);
      verifyNoMoreInteractions(client);
    });

    test(
      'should throw [APIException] when the status code is not 200 or '
      '201',
      () async {
        when(() => client.post(any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'))).thenAnswer(
          (_) async => http.Response('Invalid email address', 400),
        );
        final methodCall = remoteDataSource.createUser;

        expect(
            () async => methodCall(
                  createdAt: 'createdAt',
                  name: 'name',
                  avatar: 'avatar',
                ),
            throwsA(const ApiException(
                message: 'Invalid email address', statusCode: 400)));

        verify(() => client.post(
              Uri.parse('${kBaseUrl}users'),
              headers: {'Content-Type': 'application/json'}, // Match headers
              body: jsonEncode({
                'createdAt': 'createdAt',
                'name': 'name',
                'avatar': 'avatar',
              }),
            )).called(1);

        verifyNoMoreInteractions(client);
      },
    );
  });

  group('getUsers', () {
    final tUsers = [const UserModel.empty()];
    test("should return [List<User>] when the status code is 200", () async {
      // Arrange
      when(() => client.get(
            any(),
          )).thenAnswer(
        (_) async => http.Response(jsonEncode([tUsers.first.toMap()]), 200),
      );
      // Act
      final methodCall = await remoteDataSource.getUsers();
      // Assert
      expect(methodCall, equals(tUsers));
      verify(() => client.get(
            Uri.https(kBaseUrlWithoutHttps, "/test-api/users"),
          )).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  test("throw ApiException when the status code is 500", () async {
    // Arrange
    when(() => client.get(any()))
        .thenAnswer((_) async => http.Response("Internal Server Error", 500));
    
    final methodCall = remoteDataSource.getUsers;

    expect(()=> methodCall(), throwsA(
      const ApiException(
        message: "Internal Server Error",
        statusCode: 500,
      ),
    ));

    verify(() => client.get(
      Uri.https(kBaseUrlWithoutHttps, "/test-api/users"),
    )).called(1);
  });
}