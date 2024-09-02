import 'package:tdd_and_clean_architecture/core/utils/typedef.dart';

abstract class UsecaseWithParams<T,Params>{
  const UsecaseWithParams();
  ResultFuture<T> call(Params params);
}

abstract class UsecaseWithOutParams<T>{
  const UsecaseWithOutParams();
  ResultFuture<T> call();
}