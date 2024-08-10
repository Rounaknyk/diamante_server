import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diamanteblockchain/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class FirebaseService{
  Future<UserModel?> getData(uid) async {
    final data = await firestore.collection('Users').doc(uid).get();

    return UserModel(name: data['name'], email: data['email'], role: data['role'], publicKey: data['pubicKey'], privateKey: data['privateKey']);
  }

  Future<List<UserModel?>> getAllUsers() async {
    final data = await firestore.collection('Users').get();
    List<UserModel> umList = [];
    for(var user in data.docs){
      print(user['name']);
      umList.add(UserModel(name: user['name'], publicKey: user['publicKey'], email: user['email'], role: user['role'], privateKey: user['privateKey']));
    }

    return umList;
  }
}