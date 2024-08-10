import 'package:diamanteblockchain/constants.dart';
import 'package:diamanteblockchain/screens/connect_screen.dart';
import 'package:diamanteblockchain/screens/home_screen.dart';
import 'package:diamanteblockchain/screens/login_screen.dart';
import 'package:diamanteblockchain/screens/register_screen.dart';
import 'package:diamanteblockchain/screens/select_role_screen.dart';
import 'package:diamanteblockchain/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDyCSVrbEipFYYwFmC2ejt3O7jnSAqL1J4",
        authDomain: "diamante-363d8.firebaseapp.com",
        projectId: "diamante-363d8",
        storageBucket: "diamante-363d8.appspot.com",
        messagingSenderId: "761115126999",
        appId: "1:761115126999:web:d9657cff8bbe56af915492",
        measurementId: "G-1RLQKHPSJL"
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(auth!.currentUser);
  }
  // This widget is the root of your application.
  //If I click a butto
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Baloo',
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: kPrimaryColor)
      ),
      initialRoute: '/connect',
      // initialRoute: auth!.currentUser == null ? '/home' : '/home',
      routes: {
        '/' : (context) => WelcomeScreen(),
        '/login' : (context) => LoginScreen(),
        '/register' : (context) => RegisterScreen(),
        '/home' : (context) => HomeScreen(pKey: '',),
        '/connect' : (context) => ConnectScreen(role: 'government', name: 'Rounak',),
      },
    );
  }
}