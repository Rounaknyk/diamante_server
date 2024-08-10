import 'package:flutter/material.dart';

import '../constants.dart';
import '../custom/custom_button.dart';
import '../custom/icon_textfield.dart';
import '../models/user_model.dart';
import '../services/create_account.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({required this.isOrg});
  bool isOrg;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  String? name, email, phone;
  UserModel? accModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(''),
              IconTextField(hintText: 'Enter your name', icon: Icons.person, onChanged: (value){
                setState(() {
                  print(value);
                  name = value;
                });
              }),
              SizedBox(height: 16.0,),
              IconTextField(hintText: 'Enter your phone', icon: Icons.phone, onChanged: (value){
                setState(() {
                  print(value);
                  phone = value;
                });
              }, inputType: TextInputType.number,),
              SizedBox(height: 16.0,),
              IconTextField(hintText: 'Enter your email', icon: Icons.person, onChanged: (value){
                setState(() {
                  print(value);
                  email = value;
                });
              }, inputType: TextInputType.emailAddress,),
              SizedBox(height: 32,),

              CustomButton(text: 'Create Account', backgroundColor: kPrimaryColor, onPressed: () async {
                // accModel = await CreateAccount(context).create();
                // print("name: $name");
                // print("MODEL DATA1: ${accModel!.childJson.id}");
                // print("MODEL DATA2: ${accModel!.parentJson}");
                // print("MODEL DATA3: ${accModel!.pairSecretKey}");
                // print("MODEL DATA4: ${accModel!.pairPublicKey}");
                // print("MODEL DATA5: ${accModel!.childPublicKey}");
                // UserModel userModel = UserModel(name: name!, email: email!, phone: phone!, accModel: accModel!);
                // await storeUserModel(userModel);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
