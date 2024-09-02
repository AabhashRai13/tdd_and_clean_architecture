import 'package:tdd_and_clean_architecture/core/usecase/usecase.dart';
import 'package:tdd_and_clean_architecture/core/utils/typedef.dart';
import 'package:tdd_and_clean_architecture/features/authentication/domain/enitites/user.dart';
import 'package:tdd_and_clean_architecture/features/authentication/domain/repositories/authentication_repository.dart';

class GetUsers extends UsecaseWithOutParams<List<User>> {
  final AuthenticationRepository repository;

  GetUsers(this.repository);

  @override
  ResultFuture< List<User>> call() async {
    return await repository.getUsers();
  }
}