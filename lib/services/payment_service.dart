import 'dart:convert';

import 'package:diamanteblockchain/models/account_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class PaymentServices{

  BuildContext context;
  PaymentServices(this.context);


  Future sendAssets(userPublicKey, amount, childPublicKey, assetName, userSecretKey) async {
    try{
      http.Response res = await http.post(
          Uri.parse('http://$kUrl/send-payment'), body: jsonEncode({
        "userPublicKey" : userPublicKey,
        "userSecretKey" : userSecretKey,
        "amount" : amount,
        "childPublicKey" : childPublicKey,
        "assetName" : assetName,

      },), headers: {"Content-Type": "application/json"});

      print("PAYMENT RESPONSE : ${jsonDecode(res.body)['text']}");
      return jsonDecode(res.body)['text'];
    }catch(E){
      print("Flutter payment error: $E");
      return {};
    }
  }

  Future sendPaymentToWorker(parentPublicKey, amount, workerPublicKey, assetName) async {
    try{
      http.Response res = await http.post(
          Uri.parse('http://$kUrl/send-payment-to-worker'), body: jsonEncode({
        "parentPublicKey" : parentPublicKey,
        "amount" : amount,
        "workerPublicKey" : workerPublicKey,
        "assetName" : assetName
      },), headers: {"Content-Type": "application/json"});

      print("PAYMENT RESPONSE : ${jsonDecode(res.body)['text']}");
      return jsonDecode(res.body)['text'];
    }catch(E){
      print("Flutter payment error: $E");
      return {};
    }
  }

  Future sendPaymentToContractor(parentPublicKey, amount, contractorPublicKey, assetName) async {
    try{
      http.Response res = await http.post(
          Uri.parse('http://$kUrl/send-payment-to-contractor'), body: jsonEncode({
        "parentPublicKey" : parentPublicKey,
        "amount" : amount,
        "contractorPublicKey" : contractorPublicKey,
        "assetName" : assetName,
      },), headers: {"Content-Type": "application/json"});

      print("PAYMENT RESPONSE : ${jsonDecode(res.body)['text']}");
      return jsonDecode(res.body)['text'];
    }catch(E){
      print("Flutter payment error: $E");
      return {};
    }
  }
}