import 'package:flutter/material.dart';

class Alert{

  BuildContext context;
  Alert({required this.context});
  alert(text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${text}'), backgroundColor: Colors.redAccent,));
  }

  msg(text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${text}'), backgroundColor: Colors.green,));
  }


}
