import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diamanteblockchain/class/local_data.dart';
import 'package:diamanteblockchain/custom/custom_button.dart';
import 'package:diamanteblockchain/screens/home_screen.dart';
import 'package:diamanteblockchain/services/create_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../class/alert.dart';
import '../constants.dart';
import 'dart:js' as js;

class ConnectScreen extends StatefulWidget {
  ConnectScreen({required this.role, required this.name});

  String role, name;
  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {

  String pKey = '';

  void checkDiamExtension() async {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(pKey: pKey)));


    if (js.context.hasProperty('diam')) {
      print("Diam extension is installed!");
      try {
        var connectResult = js.context['diam'].callMethod('connect');

        if (connectResult is js.JsObject && connectResult.hasProperty('then')) {
          // If it's a Promise-like object
          connectResult.callMethod('then', [
                (result) {
              setState(() {
                pKey = result['message'][0];
              });
              print("LOLL $pKey");

                  // Alert(context: context).alert(result as js.JsObject);
            }
          ]).callMethod('catch', [
                (error) {
              print('Error: $error');
            }
          ]);
          print("BHEN");
          print(pKey);
          LocalData().saveToLocalStorage('parentPublicKey', pKey);

          // if(pKey != null && pKey.isNotEmpty){
            // String uid = FirebaseAuth.instance.currentUser!.uid;
            // await CreateAccount(context).createParentAcc(pKey);
            // await FirebaseFirestore.instance.collection('Users').doc(uid).set({
            //   'publicKey' : pKey
            //
            // }, SetOptions(merge: true));
            // LocalData().saveToLocalStorage('primaryKey', pKey);
            // LocalData().saveToLocalStorage('uid', uid);
            await CreateAccount(context).createParentAcc(pKey);

            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(pKey: pKey, role: widget.role,)));
          // }
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(pKey: pKey, role: widget.role)));
          // If it's not a Promise-like object, assume it's the result directly
          print('User active public key is: ${connectResult['message'][0]}');
        }
      } catch (e) {
        print('Error connecting to Diam: $e');
      }
    } else {
      print("Diam extension is not installed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset('animations/connect.json', height: size.height * 0.2, width: size.width * 0.2,),
              SizedBox(height: 16.0,),
              RichText(text: TextSpan(
          style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 32, fontFamily: 'Baloo'),
                  children: [
                    TextSpan(text: 'Hey ', style: TextStyle(color: Colors.black, )),
                    TextSpan(text: '${widget.name}!', ),
                  ]
              )),
              SizedBox(height: 16.0,),
              Text('Connect your wallet and get started!', style: TextStyle(fontSize: 28, color: Colors.black.withOpacity(0.8), fontWeight: FontWeight.bold),),
              SizedBox(height: 32.0,),
              Container(child: CustomButton(text: 'CONNECT', backgroundColor: kPrimaryColor, onPressed: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(pKey: pKey)));

                checkDiamExtension();
                // func();
              }), width: 100,),
            ],
          ),
        ),
      ),
    );
  }
}
