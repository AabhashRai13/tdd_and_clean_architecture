part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class CreateUserEvent extends AuthenticationEvent {
  final String createdAt;
  final String name;
  final String avatar;

  const CreateUserEvent({
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  @override
  List<Object> get props => [createdAt, name, avatar];
}

class GetUsersEvent extends AuthenticationEvent {
  final List<User> users;

  const GetUsersEvent({
    required this.users,
  });

  @override
  List<Object> get props => [users];
}
