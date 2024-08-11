import 'dart:convert';

import 'package:diamanteblockchain/models/account_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';


class CreateAccount{

  BuildContext context;
  CreateAccount(this.context);

  Future<AccountModel?> create() async {
    try{
      http.Response res = await http.post(
          Uri.parse('$kUrl/create-account'), body: jsonEncode({
      },), headers: {"Content-Type": "application/json"});

      print(jsonDecode(res.body));
      return AccountModel.fromJson(jsonDecode(res.body));
    }catch(E){
      print("Flutter error: $E");
      return null;
    }
  }


  Future createTrust(assetName, parentPublicKey, childPublicKey) async {
    try{
      http.Response res = await http.post(
          Uri.parse('$kUrl/create-trust'), body: jsonEncode({
        'parentPublicKey': parentPublicKey,
        'childPublicKey' : childPublicKey,
        'assetName' : assetName
      },), headers: {"Content-Type": "application/json"});

      print("TRUST ${jsonDecode(res.body)['text']}");
      return jsonDecode(res.body)['text'];
    }catch(E){
      print("Flutter error: $E");
      return {};
    }
  }

  Future mint(assetName, amount, parentPublicKey, childPublicKey) async {
    try{
      http.Response res = await http.post(
          Uri.parse('$kUrl/mint'), body: jsonEncode({
        'assetName' : assetName,
        'amount' : amount,
        'parentPublicKey' : parentPublicKey,
        'childPublicKey' : childPublicKey
      },), headers: {"Content-Type": "application/json"});

      print("BHAI ${jsonDecode(res.body)['text']}");
      return jsonDecode(res.body)['text'];
    }catch(E){
      print("Flutter error: $E");
      return null;
    }
  }

  Future createParentAcc(pKey) async {
    try{
      http.Response res = await http.post(
          Uri.parse('$kUrl/create-parent-account'), body: jsonEncode({
        "key" : pKey
      },), headers: {"Content-Type": "application/json"});

      print(jsonDecode(res.body));
      if(jsonDecode(res.body)['details'].toString().contains("createAccountAlreadyExist"))
        throw jsonDecode(res.body);
      return (jsonDecode(res.body));
    }catch(E){
      if(E == 'exists')
        return E;
      print("Flutter error: $E");
      return null;
    }
  }

  Future getTrx(String key) async {
    try{
      print("reached");
      http.Response res = await http.post(
          Uri.parse('$kUrl/trx'), body: jsonEncode({
        "key" : key
      },), headers: {"Content-Type": "application/json"});

      // print(jsonDecode(res.body));
      print(jsonDecode(res.body));
      return jsonDecode(res.body);

    }catch(E){
      print("Flutter error: $E");
      return null;
    }
  }
}