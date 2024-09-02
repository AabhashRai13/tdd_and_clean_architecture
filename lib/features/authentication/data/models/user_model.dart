import 'dart:convert';

import 'package:tdd_and_clean_architecture/core/utils/typedef.dart';
import 'package:tdd_and_clean_architecture/features/authentication/domain/enitites/user.dart';

class UserModel extends User{
  const UserModel({
    required super.id,
    required super.createdAt,
    required super.name,
    required super. avatar,
  } );
  
  const UserModel.empty()
      : this(id : '_empty.id',
        createdAt : '_empty.createdAt',
        name : '_empty.name',
        avatar : '_empty.avatar');
        
  UserModel copyWith({
    String? id,
    String? createdAt,
    String? name,
    String? avatar,
  }){
    return UserModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  } 

 factory UserModel.fromJson(DataMap json){
    return UserModel(
      id: json['id'],
      createdAt: json['createdAt'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }
  DataMap toMap(){
    return {
      'id': id,
      'createdAt': createdAt,
      'name': name,
      'avatar': avatar,
    };
  }

  String toJson() => jsonEncode(toMap());
}