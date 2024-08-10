import 'dart:async';
import 'dart:convert';

import 'package:diamanteblockchain/constants.dart';
import 'package:diamanteblockchain/custom/custom_button.dart';
import 'package:diamanteblockchain/custom/icon_textfield.dart';
import 'package:diamanteblockchain/models/account_model.dart';
import 'package:diamanteblockchain/models/user_model.dart';
import 'package:diamanteblockchain/screens/account_screen.dart';
import 'package:diamanteblockchain/screens/home_screen.dart';
import 'package:diamanteblockchain/services/create_account.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({super.key});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {

  String? name, email, phone;
  AccountModel? accModel;
  bool isOrg = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Select your role', style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),),
                  SizedBox(height: 16.0,),
                  InkWell(
                    onTap: (){
                      setState(() {
                        isOrg = true;
                        Timer(Duration(milliseconds: 500), (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AccountScreen(isOrg: isOrg)));
                        });
                      });
                    },
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        height: size.height * 0.3,
                        width: size.width * 0.7,
                        child: Column(
                          children: [
                            Expanded(child: LottieBuilder.asset('assets/gov.json')),
                            SizedBox(height: 8.0,),
                            Text('Organisation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isOrg ? Colors.white : Colors.black),),
                          ],
                        ),
                        decoration: BoxDecoration(color: isOrg ? Colors.blue : Colors.white, borderRadius: BorderRadius.circular(12),),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0,),
                  InkWell(
                    onTap: (){
                      setState(() {
                        isOrg = false;
                        Timer(Duration(milliseconds: 500), (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AccountScreen(isOrg: isOrg)));
                        });
                      });
                    },
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        height: size.height * 0.3,
                        width: size.width * 0.7,
                        child: Column(
                          children: [
                            Expanded(child: LottieBuilder.asset('assets/contractor.json')),
                            SizedBox(height: 8.0,),
                            Text('Contractor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: !isOrg ? Colors.white : Colors.black),),
                          ],
                        ),
                        decoration: BoxDecoration(color: !isOrg ? Colors.blue : Colors.white, borderRadius: BorderRadius.circular(12),),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0,),
                  // CustomButton(text: 'LOGIN', backgroundColor: kPrimaryColor, onPressed: () async {
                  //   // await login();
                  // }),
                  SizedBox(height: 16.0,),
                  InkWell(child: Text('Already have a token? Click here!', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),), onTap: (){
              
                  },),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}