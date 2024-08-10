import 'package:flutter/material.dart';

class WorkerModel{
  String name, publicKey, balance;

  WorkerModel({required this.publicKey, required this.name , this.balance = '0'});
}