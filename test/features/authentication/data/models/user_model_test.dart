import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_and_clean_architecture/core/utils/typedef.dart';
import 'package:tdd_and_clean_architecture/features/authentication/data/models/user_model.dart';
import '../../../../fixtures/fixture_reader.dart';
void main() {
  const tmodel = UserModel.empty();
  test("shlould be a sublcass of [User] entity", () {
    // Assert
    expect(tmodel, isA<UserModel>());
  });
  final tJson = fixture("user.json");
  final tMap = jsonDecode(tJson) as DataMap;
  group("fromMap", () {
    test("should return a [UserModel] with the right data", () {
      // Act
      final result = UserModel.fromJson(tMap);
      expect(result, equals(tmodel));
    });
  });

  group("toMap", () {
    test("should return a [DataMap] with the right data", () {
      //Act
      final result = tmodel.toMap();
      //Assert
      expect(result, equals(tMap));
    });
  });

  group("toJson", () {
    test("should return a [JSON] with the right data", () {
      //Act
      final result = tmodel.toJson();
      final tJson = jsonEncode({
        "id": "_empty.id",
        "createdAt": "_empty.createdAt",
        "name": "_empty.name",
        "avatar": "_empty.avatar"
      });
      //Assert
      expect(result, equals(tJson));
    });
  });

  group("copyWith", () {
    test("should return a [UserModel] with different Data", () {
      //Act
      final result = tmodel.copyWith(
        id: "1",  
      );
      //Assert
      expect(
          result.id,
          equals("1"));
          expect(result, isNot(tmodel));
    });
  });
}