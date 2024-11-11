import 'package:hive_flutter/hive_flutter.dart';
import 'package:stockzen/models/usermodel.dart';

Future<void> addUser(UserModel user) async {
  final userBox = await Hive.openBox<UserModel>('user_db');
  userBox.add(user);
}

Future<bool> checkUserLogin() async {
  final checkUserBox = await Hive.openBox<UserModel>('user_db');
  if (checkUserBox.isEmpty) {
    return false;
  }
  return true;
}

Future<UserModel> fetchUser() async {
  final userBox = await Hive.openBox<UserModel>('user_db');
  // userBox.values.where((value) => value.name == name);
  // return userBox.values.toList().firstWhere((value) => value.name == name);
  return userBox.values.first;
}

Future<void> updateUser(UserModel user) async {
  final userBox = await Hive.openBox<UserModel>('user_db');
  userBox.putAt(0, user);
}

Future<UserModel> getUser() async {
  final userBox = await Hive.openBox<UserModel>('user_db');
  final user = userBox.getAt(0);
  return user!;
}
