
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTimer();
  }

  setTimer()  {
    Timer(Duration(seconds: 4), (){
      Navigator.pushNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset('animations/logo.json', height: size.height * 0.3, width: size.width * 0.3,),
            SizedBox(height: 32.0,),
            Text('DIAM FLOW', style: TextStyle(fontSize: 32, color: Colors.black, fontWeight: FontWeight.bold),),
            SizedBox(height: 16.0,),
            Text('Streamlining financial transactions on the Diamante Blockchain!', style: TextStyle(fontSize: 24),),
          ],
        ),
      ),
    );
  }
}
