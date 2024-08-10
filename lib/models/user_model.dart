import 'package:flutter/material.dart';

class UserModel{
  String name, role, email, publicKey, privateKey;

  UserModel({required this.name, required this.publicKey, required this.email, required this.role, this.privateKey = ''});
}