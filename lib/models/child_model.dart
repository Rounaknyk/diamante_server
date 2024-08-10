import 'package:flutter/material.dart';

class ChildModel{
  String id, childPublicKey,childSecretKey, assetName, balance, parentPubicKey;

  ChildModel({required this.id, required this.childPublicKey, required this.assetName, required this.childSecretKey, required this.balance, required this.parentPubicKey});

}