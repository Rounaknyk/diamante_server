import 'package:diamanteblockchain/class/alert.dart';
import 'package:diamanteblockchain/class/firebase_service.dart';
import 'package:diamanteblockchain/class/local_data.dart';
import 'package:diamanteblockchain/constants.dart';
import 'package:diamanteblockchain/custom/custom_button.dart';
import 'package:diamanteblockchain/custom/icon_textfield.dart';
import 'package:diamanteblockchain/custom/reusable_textfield.dart';
import 'package:diamanteblockchain/models/user_model.dart';
import 'package:diamanteblockchain/screens/home_screen.dart';
import 'package:diamanteblockchain/screens/register_screen.dart';
import 'package:diamanteblockchain/screens/select_role_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'dart:html' as html;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool loading = false;

  String email = '', password = '';
  login() async {
    try{
      setState(() {
        loading = true;
      });
      FirebaseAuth auth = FirebaseAuth.instance;

      await auth.signInWithEmailAndPassword(email: email, password: password);
      LocalData().saveToLocalStorage('uid', auth.currentUser!.uid);
      UserModel? um = await FirebaseService().getData(auth.currentUser!.uid);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(pKey: LocalData().loadStoredValue('parentPublicKey'), um: um)));
    }catch(e){
      Navigator.pushNamed(context, '/connect');
      // Alert(context: context).alert(e);
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  void _loadStoredValue() {
    setState(() {
       print(html.window.localStorage['myKey']);
    });
  }

  void _saveToLocalStorage(data) {
    html.window.localStorage['myKey'] = data;
    _loadStoredValue();
  }

  void _clearLocalStorage() {
    html.window.localStorage.remove('myKey');
    _loadStoredValue();
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
                      height: size.height * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Text('Welcome Back!', style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),)),
                          SizedBox(height: 24.0,),
                          Text('Email: ', style: TextStyle(fontSize: 16),),
                          SizedBox(height: 8.0,),
                          Container(child: IconTextField(hintText: 'Enter your email', icon: Icons.email, onChanged: (value){
                            setState(() {
                              email = value;
                              print(email);
                            });
                          },), width: size.width * 0.3,),
                          SizedBox(height: 16.0,),
                          Text('Password: ', style: TextStyle(fontSize: 16),),
                          SizedBox(height: 8.0,),
                          Container(child: IconTextField(hintText: 'Enter your password', icon: Icons.password, onChanged: (value){
                            setState(() {
                              password = value;
                            });
                          }), width: size.width * 0.3),
                          SizedBox(height: 32,),
                          Container(child: CustomButton(text: 'LOGIN', backgroundColor: kPrimaryColor, onPressed: (){
                            _loadStoredValue();
                            // _saveToLocalStorage('HELLOO!');
                            login();
                          }), width: size.width * 0.3),
                          SizedBox(height: 32,),
                          Hero(
                            tag: 'hero',
                            child: InkWell(
                              onTap: (){
                                Navigator.pushNamed(context, '/register');
                                // Navigator.pushNamed(context, '/register');
                              },
                              child: RichText(text: TextSpan(
                                style: TextStyle(fontSize: 16),
                                children: [
                                  TextSpan(text: 'Haven\'t Registered yet ? '),
                                  TextSpan(text: 'Register here', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                                ]
                              )),
                            ),
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
            Positioned(child: Image.asset('assets/laptop.png', ), right: 40, top: 20,),
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
