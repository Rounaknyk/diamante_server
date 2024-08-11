import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diamanteblockchain/class/alert.dart';
import 'package:diamanteblockchain/constants.dart';
import 'package:diamanteblockchain/custom/custom_button.dart';
import 'package:diamanteblockchain/custom/icon_textfield.dart';
import 'package:diamanteblockchain/custom/reusable_textfield.dart';
import 'package:diamanteblockchain/screens/connect_screen.dart';
import 'package:diamanteblockchain/screens/select_role_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../class/local_data.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  String name = '', email = '', pass = '', role = 'select a role';
  bool loading = false;

  register() async {
    setState(() {
      loading = true;
    });
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(email: email, password: pass);
      await auth.currentUser!.updateDisplayName(name);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String uid = auth.currentUser!.uid;
      final data = await firestore.collection('Users').doc(uid).set({
        'name' : name,
        'uid' : auth.currentUser!.uid,
        'email' : email,
        'role' : role,
        'publicKey': '',
        'privateKey': '',
      });

      LocalData().saveToLocalStorage('uid', uid);

      print('done');
      Alert(context: context).msg('Registered!');
      setState(() {
        loading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectScreen(role: role, name: name)));
      // Navigator.pushNamed(context, '/connect');
    }catch(e){
      setState(() {
        loading = false;
      });
      print(e);
      Alert(context: context).alert(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              children: [
                // SvgPicture.asset('svgs/laptop.svg', height: 100, width: 100,),
                Container(

                  width: size.width * 0.65,
                  height: double.infinity,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Center(
                    child: Container(
                      width: size.width * 0.3,
                      height: size.height * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: RichText(text: TextSpan(
                          style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(text: 'Welcome '),
                                  TextSpan(text: '${name} !', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                ]
                            ),),
                          ),
                          // Center(child: Text('Welcome ${name}!', style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),)),
                          SizedBox(height: 24.0,),
                          Text('Name: ', style: TextStyle(fontSize: 16),),
                          SizedBox(height: 8.0,),
                          IconTextField(hintText: 'Enter your name', icon: Icons.person, onChanged: (value){
                            setState(() {
                              name = value;
                            });
                          }),
                          SizedBox(height: 16.0,),
                          Text('Email: ', style: TextStyle(fontSize: 16),),
                          SizedBox(height: 8.0,),
                          IconTextField(hintText: 'Enter your email', icon: Icons.email, onChanged: (value){
                            setState(() {
                              email = value;
                            });
                          }),
                          SizedBox(height: 16.0,),
                          Text('Password: ', style: TextStyle(fontSize: 16),),
                          SizedBox(height: 8.0,),
                          IconTextField(hintText: 'Enter your password', icon: Icons.password, onChanged: (value){
                            setState(() {
                              pass = value;
                            });
                          }, isSecured: true,),
                          SizedBox(height: 16.0,),
                          Text('Select role: ', style: TextStyle(fontSize: 16),),
                          SizedBox(height: 8.0,),
                          Container(
                            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: kGrey,), borderRadius: BorderRadius.circular(12)),
                            child: DropdownButton(items: [
                              DropdownMenuItem(child: Text('Select a role'), value: 'select a role',),
                              DropdownMenuItem(child: Text('Organisation/Government'), value: 'government',),
                              DropdownMenuItem(child: Text('Middle man'), value: 'contractor',),
                            ], onChanged: (value){
                              setState(() {
                                role = value!;
                              });
                            }, isExpanded: true, underline: Container(), elevation: 5, value: role, padding: EdgeInsets.all(4.0), borderRadius: BorderRadius.circular(12), dropdownColor: Colors.white,),
                          ),
                          SizedBox(height: 32,),
                          CustomButton(text: 'REGISTER', backgroundColor: kPrimaryColor, onPressed: () async {
                            if(role == 'select a role')
                              Alert(context: context).alert('Select a role!');
                            else if(name.isEmpty || email.isEmpty || pass.isEmpty)
                              Alert(context: context).alert('Fill all fields!');
                            else if(pass.length < 6)
                              Alert(context: context).alert('Password cannot be less than 6');
                            else if(!email.contains('@'))
                              Alert(context: context).alert('Invalid email');
                            else if(role == 'select a role')
                              Alert(context: context).alert('Please select a role');
                            else
                              await register();
                          }, loadingWidget: Center(child: CircularProgressIndicator(color: Colors.white,),), isLoading: loading,),
                          SizedBox(height: 32,),
                          InkWell(
                            onTap: () async {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: RichText(text: TextSpan(
                                style: TextStyle(fontSize: 16),
                                children: [
                                  TextSpan(text: 'Already registered ? '),
                                  TextSpan(text: 'Login here', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                ],
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.35,
                  height: double.infinity,
                  decoration: BoxDecoration(color: kPrimaryColor),
                  // child: Image.asset('assets/laptop.png'),
                  // child: LottieBuilder.asset('animations/login.json'),
                ),
              ],
            ),
            Positioned(child: Hero(child: Image.asset('assets/laptop.png', ), tag: 'hero',), right: 40, top: 20,),
            Positioned(child: SvgPicture.asset('svgs/element.svg',), bottom: 0, left: 0,),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   body: SafeArea(
    //     child: Padding(
    //       padding: EdgeInsets.all(16.0),
    //       child: Center(
    //         child: Material(
    //           elevation: 5,
    //           borderRadius: BorderRadius.circular(12),
    //           child: Container(
    //             padding: EdgeInsets.all(16.0),
    //             decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
    //             height: size.height * 0.9,
    //             width: size.width * 0.3,
    //             child: SingleChildScrollView(
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Text('Login here', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),),
    //                   SizedBox(height: 8.0,),
    //                   Text('Please enter the secret key which was generated by your account when you tried to sign up.', style: TextStyle(), textAlign: TextAlign.center,),
    //                   LottieBuilder.asset('assets/login.json', height: size.height * 0.4, width: size.width * 0.3,),
    //                   IconTextField(hintText: 'Enter your email', icon: Icons.email, onChanged: (value){
    //
    //                   }, inputType: TextInputType.emailAddress,),
    //                   SizedBox(height: 16.0,),
    //                   IconTextField(hintText: 'Enter your password', icon: Icons.password, onChanged: (value){
    //
    //                   }, inputType: TextInputType.text, isSecured: true,),
    //                   SizedBox(height: 16.0,),
    //                   CustomButton(text: 'LOGIN', backgroundColor: kPrimaryColor, onPressed: () async {
    //                     await login();
    //                   }),
    //                   SizedBox(height: 16.0,),
    //                   InkWell(child: Text('Don\'t have an account? Create account here', style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),), onTap: (){
    //                     Navigator.push(context, MaterialPageRoute(builder: (context) => SelectRoleScreen()));
    //                   },)
    //                 ],
    //               ),
    //             ),
    //           ),
    //         )
    //       ),
    //     ),
    //   ),
    // );

  }
}
