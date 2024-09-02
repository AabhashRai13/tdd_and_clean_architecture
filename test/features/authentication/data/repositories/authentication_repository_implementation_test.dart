import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_and_clean_architecture/core/errors/exceptions.dart';
import 'package:tdd_and_clean_architecture/core/errors/failure.dart';
import 'package:tdd_and_clean_architecture/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_and_clean_architecture/features/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_and_clean_architecture/features/authentication/domain/enitites/user.dart';


class MockAuthenticationRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource dataSource;
  late AuthenticationRepositoryImplementation repository;
  const createdAt = "whatever.createdAt";
  const name = "whatever.name";
  const avatar = "whatever.avatar";
  setUp(() {
    dataSource = MockAuthenticationRemoteDataSource();
    repository = AuthenticationRepositoryImplementation(dataSource);
  });
  const tException = ApiException(message: 'Server Failure', statusCode: 500);
  const expectedUsers = [User.empty()];

  group("Create user", () {
    test(
        "should call the [RemotDataSource.createUser] and complete successfully"
        "when the call to the remote source is successful", () async {
      // Arrange
      when(() => dataSource.createUser(
            createdAt: any(named: "createdAt"),
            name: any(named: "name"),
            avatar: any(named: "avatar"),
          )).thenAnswer((_) async => Future.value());
      // Act
      final result = await repository.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );
      // Assert
      expect(result, equals(const Right(null)));
      verify(() => dataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          )).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test(
        "Should return a [Api Failure] when the call to the remote"
        "Source is unsuccessful", () async {
      // Arrange
      when(() => dataSource.createUser(
            createdAt: any(named: "createdAt"),
            name: any(named: "name"),
            avatar: any(named: "avatar"),
          )).thenThrow(tException);
      //act
      final result = await repository.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );
      // Assert
      expect(
          result,
          equals(Left(ApiFailure(
              message: tException.message,
              statusCode: tException.statusCode))));
      verify(() => dataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          )).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });

  group("Get User", () {
    test(
        "should call the [RemotDataSource.getUser] and return [List<User>]"
        "when the call to the remote source is successful", () async {
      // Arrange
      when(() => dataSource.getUsers())
          .thenAnswer((_) async => Future.value(expectedUsers));
      // Act
      final result = await repository.getUsers();
      // Assert
      expect(result, isA<Right<dynamic, List<User>>>());

      verify(() => dataSource.getUsers()).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test(
        "[Get USER] Should return a [API FAILURE] when the call to the remote"
        "source is unsuccessful", () async {
      // Arrange
      when(() => dataSource.getUsers()).thenThrow(tException);
      //act
      final result = await repository.getUsers();
      // Assert
      expect(
          result,
          equals(Left(ApiFailure(
              message: tException.message,
              statusCode: tException.statusCode))));
      verify(() => dataSource.getUsers()).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}
