import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_and_clean_architecture/features/authentication/domain/enitites/user.dart';
import 'package:tdd_and_clean_architecture/features/authentication/domain/usecases/create_user.dart';
import 'package:tdd_and_clean_architecture/features/authentication/domain/usecases/get_users.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required CreateUser createUser,
    required GetUsers getUsers,
  })  : _createUser = createUser,
        _getUsers = getUsers,
        super(AuthenticationInitial()) {
    on<CreateUserEvent>(_createUserHandler);
    on<GetUsersEvent>(_getUsersHandler);
  }

  final CreateUser _createUser;
  final GetUsers _getUsers;

  Future<void> _createUserHandler(
      CreateUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(CreatingUser());
    final result = await _createUser(CreateUserParams(
      createdAt: event.createdAt,
      name: event.name,
      avatar: event.avatar,
    ));
    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (_) => emit(UserCreated()),
    );
  }

  Future<void> _getUsersHandler(
      GetUsersEvent event, Emitter<AuthenticationState> emit) async {
    emit(GettingUsers());
    final result = await _getUsers();
    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (users) => emit(UsersLoaded(users)),
    );
  }
}