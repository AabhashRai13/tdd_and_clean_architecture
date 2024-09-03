import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_and_clean_architecture/core/errors/failure.dart';
import 'package:tdd_and_clean_architecture/features/authentication/domain/usecases/create_user.dart';
import 'package:tdd_and_clean_architecture/features/authentication/domain/usecases/get_users.dart';
import 'package:tdd_and_clean_architecture/features/authentication/presentation/cubit/authentication_cubit.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late MockCreateUser mockCreateUser;
  late MockGetUsers mockGetUsers;
  late AuthenticationCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tApiFailure = ApiFailure(message: "Api Failure", statusCode: 500);

  setUp(() {
    mockCreateUser = MockCreateUser();
    mockGetUsers = MockGetUsers();
    cubit =
        AuthenticationCubit(createUser: mockCreateUser, getUsers: mockGetUsers);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be [AuthenticationInitial]', () {
    expect(cubit.state, AuthenticationInitial());
  });

  group("createUser", () {
    blocTest<AuthenticationCubit, AuthenticationState>(
        "Should emit [CreatingUser, UserCreated] when successfull",
        build: () {
          when(() => mockCreateUser(tCreateUserParams))
              .thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.createUser(
            createdAt: tCreateUserParams.createdAt,
            name: tCreateUserParams.name,
            avatar: tCreateUserParams.avatar),
        expect: () => [
              CreatingUser(),
              UserCreated(),
            ],
        verify: (_) {
          verify(() => mockCreateUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(mockCreateUser);
        });
  });

  blocTest<AuthenticationCubit, AuthenticationState>(
      "Should emit [CreatingUser, AuthenticationError] when failed",
      build: () {
        when(() => mockCreateUser(tCreateUserParams))
            .thenAnswer((_) async => const Left(tApiFailure));
        return cubit;
      },
      act: (cubit) => cubit.createUser(
          createdAt: tCreateUserParams.createdAt,
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar),
      expect: () =>
          [CreatingUser(), AuthenticationError(tApiFailure.errorMessage)],
      verify: (_) {
        verify(() => mockCreateUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(mockCreateUser);
      });

  group("getUsers", () {
    blocTest<AuthenticationCubit, AuthenticationState>(
        "Should emit [GettingUsers, UsersLoaded] when successfull",
        build: () {
          when(() => mockGetUsers()).thenAnswer((_) async => const Right([]));
          return cubit;
        },
        act: (cubit) => cubit.getUsers(),
        expect: () => [
              GettingUsers(),
              const UsersLoaded([]),
            ],
        verify: (_) {
          verify(() => mockGetUsers()).called(1);
          verifyNoMoreInteractions(mockGetUsers);
        });

    blocTest<AuthenticationCubit, AuthenticationState>(
        "Should emit [GettingUsers, AuthenticationError] when failed",
        build: () {
          when(() => mockGetUsers())
              .thenAnswer((_) async => const Left(tApiFailure));
          return cubit;
        },
        act: (cubit) => cubit.getUsers(),
        expect: () => [
              GettingUsers(),
              AuthenticationError(tApiFailure.errorMessage),
            ],
        verify: (_) {
          verify(() => mockGetUsers()).called(1);
          verifyNoMoreInteractions(mockGetUsers);
        });
  });
}
