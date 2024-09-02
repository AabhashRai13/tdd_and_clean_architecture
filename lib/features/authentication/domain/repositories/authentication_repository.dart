import 'package:tdd_and_clean_architecture/core/utils/typedef.dart';
import 'package:tdd_and_clean_architecture/features/authentication/domain/enitites/user.dart';

abstract class AuthenticationRepository{
  const AuthenticationRepository();

 ResultVoid createUser({required String createdAt,required String name,required String avatar});

 ResultFuture<List<User>> getUsers();
} 