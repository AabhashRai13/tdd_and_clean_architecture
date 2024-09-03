import 'package:equatable/equatable.dart';
import 'package:tdd_and_clean_architecture/core/usecase/usecase.dart';
import 'package:tdd_and_clean_architecture/core/utils/typedef.dart';
import 'package:tdd_and_clean_architecture/features/authentication/domain/repositories/authentication_repository.dart';

class CreateUser extends UsecaseWithParams<void, CreateUserParams>{
  const CreateUser(this.authenticationRepository);

final AuthenticationRepository authenticationRepository;

  @override
  ResultVoid call(CreateUserParams params) async{
    return await authenticationRepository.createUser(
      createdAt: params.createdAt,
      name: params.name,
      avatar: params.avatar
    );
  }
} 

class CreateUserParams extends Equatable{
  final String createdAt;
  final String name;
  final String avatar;

  const CreateUserParams({required this.createdAt,required this.name,required this.avatar});

  const CreateUserParams.empty():createdAt='_empty.createdAt',name='_empty.name',avatar='_empty.avatar';

  @override
  List<Object?> get props => [createdAt,name,avatar];
}