import 'package:flutter/material.dart';

class FormatKey{

  String formatPublicKey(String publicKey) {
    if (publicKey.length <= 10) {
      return publicKey;
    }

    return '${publicKey.substring(0, 6)}...${publicKey.substring(publicKey.length - 6)}';
  }
}