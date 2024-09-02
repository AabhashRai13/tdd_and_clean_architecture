import 'package:equatable/equatable.dart';
import 'package:tdd_and_clean_architecture/core/errors/exceptions.dart';

abstract class Failure extends Equatable {
  final String message;
  final int statusCode;

  const Failure({required this.message, required this.statusCode});

  @override
  String toString() => message;

  @override
  List<Object?> get props => [message, statusCode];
}

class ApiFailure extends Failure {
  const ApiFailure({required super.message, required super.statusCode});

  ApiFailure.fromException(ApiException exception)
      : super(message: exception.message, statusCode: exception.statusCode);
}