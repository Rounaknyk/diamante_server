import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:diamanteblockchain/class/alert.dart';
import 'package:diamanteblockchain/class/local_data.dart';
import 'package:diamanteblockchain/constants.dart';
import 'package:diamanteblockchain/custom/custom_button.dart';
import 'package:diamanteblockchain/custom/icon_textfield.dart';
import 'package:diamanteblockchain/models/user_model.dart';
import 'package:diamanteblockchain/screens/home_tab.dart';
import 'package:diamanteblockchain/screens/view_transaction_tab.dart';
import 'package:diamanteblockchain/services/create_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_hover/config.dart';
import 'package:http/http.dart' as http;
import 'dart:js' as js;

import 'package:text_hover/text_hover.dart';

import '../class/format_ket.dart';
import '../models/transaction_model.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({required this.pKey,  this.um = null, this.role = "government"});
  UserModel? um;
  String pKey;
  String role;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? um;
  bool loading = false;

  Future<dynamic> promiseToFuture(Object jsPromise) {
    final completer = Completer<dynamic>();
    final success = js.allowInterop((result) => completer.complete(result));
    final error = js.allowInterop((e) => completer.completeError(e));
    js.context['Promise'].callMethod('resolve', [jsPromise]).callMethod(
        'then', [success, error]);
    return completer.future;
  }

  void signTransaction() async {
    // if (js.context.hasProperty('diam')) {
    // final transactionXdr;
    try {
      // final transactionXdr = await CreateAccount(context)
      //     .getTrx("GDUJ7O2MRH72ZRGV26RVKM7547O25JAYHOFRZZDYISYM4LNFAEGGUZA7c");
      // print(transactionXdr);
      final shouldSubmit = true;
      final network = "Diamante Testnet";
      print("Reached");
      js.context['diam'].callMethod('sign', [
        "AAAAAgAAAADE2TMk6WEWPe0CltQiU2fRuWr6UNGzU39glfcYy7rLKAAAAGQAHYokAAAAAgAAAAEAAAAAAAAAAAAAAABmtGNXAAAAAAAAAAEAAAAAAAAABgAAAAFHTQAAAAAAAFzJxu/n957G07pfMsoRZ7q/NAScdM3r+rglzDcdyKJBAAAAAlQL5AAAAAAAAAAAAA==",
        shouldSubmit,
        network
      ]).then((result) {
        print('Signature result: $result');
      }).catchError((error) {
        print('Error signing transaction: $error');
      });
    } catch (e) {
      print("TRANS ${e}");
    }
    // final transactionXdr = "AAAAAgAAAADD9u0l8B7fMgvRITQuplXFfTskVrNgTgyBN1heDfkLEAAAAGQApCseAAAAAQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAQAAAADId5UakWjIgj3XsdYXl/8mJKTpUSUIu8F3IcB7cKoQ1wAAAAAAAAAAAExLQAAAAAAAAAAA";

    // } else {
    //   print("Diam extension is not installed.");
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pKey = widget.pKey;
    print("CIN $pKey");

    // content = HomeTab(pKey: pKey, role: widget.role);
    getDetails();
    getTrans();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   checkDiamExtension();
    // });
  }

  getDetails() async {
    print("DETAILS IS ${FirebaseAuth.instance.currentUser!.uid}");
  }
  Future<dynamic> fetchOpertaions(transactionId) async {
    final url = Uri.parse('https://diamtestnet.diamcircle.io/transactions/$transactionId/operations');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        var operationType = data['_embedded']['records'][0]['type'];
        var funder = data['_embedded']['records'][0]['funder'];
        var account = data['_embedded']['records'][0]['account'];
        print("Transactions: $operationType");

        Map map = {
          "operationType": operationType,
          "funder" : funder,
          "account" : account
        };
        return map;

        // isLoading = false;
      } else {

        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      print('Error: $e');
      return 'None';
      setState(() {
        // isLoading = false;
      });
    }
  }

  List<TransModel> transList = [];

  Future<void> fetchTransactions() async {
    final url = Uri.parse('https://diamtestnet.diamcircle.io/accounts/${widget.pKey}/transactions');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        transList = [];
        var transactions = data['_embedded']['records'];
        for(var trans in transactions){
          String funderAcc = '';
          String operatioTnype = '';
          //         "operationType": operationType,
          // "funder" : funder,
          // "account" : account
          var res = await fetchOpertaions(trans['id']);
          print(trans['source_account']);
          print(trans['created_at']);
          print(res['funder']);
          print(res['operationType']);
          print(res['account']);
          // transList.add(TransModel(source_account: trans['source_account'], create_date: trans['created_at'], funder_account: res['funder'], operationType: res['operationType'], account: res['account']));
          transList.add(TransModel(source_account: FormatKey().formatPublicKey(trans['source_account']), create_date: trans['created_at'], funder_account: FormatKey().formatPublicKey(res['funder']), operationType: res['operationType'], account: FormatKey().formatPublicKey(res['account'])));
        }
        print("Transactions: $transactions");

        // isLoading = false;
        setState(() {

        });
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        // isLoading = false;
      });
    }
  }
  getTrans() async {
    setState(() {
      screenLoading = true;
    });
    await fetchTransactions();
    print('LENGTH ${transList.length}');
    setState(() {
      screenLoading = false;
    });
  }

  bool screenLoading = false;
  Widget content = Container();

  Color tranColor = Colors.black;
  Color helpColor = Colors.black;
  Color homeColor = kPrimaryColor;
  Color aboutColor = Colors.black;

  String navText = 'home';
  String pKey = '';

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: (){
      //   fetchTransactions();
      // }),
      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   // fetchTransactions();
      //   print("HIIIII");
      //   print("SECRETTTT : ${LocalData().loadStoredValue('childSecretKey')}");
      //   var xdr = await CreateAccount(context).createTrust("GM", widget.pKey, "SDCKVXEVLCBPNO3SXR6PWLIFKFHFTSYIR2PZ4PW2JDE53VDYEVU2ZRJR");
      //   // var xdr = "AAAAAgAAAABHiHdg9EIPdBsWBSThTs0X374GO62ekwEtfwnj/jGxWwAAAGQAHZCiAAAAAQAAAAEAAAAAAAAAAAAAAABmtIm/AAAAAAAAAAEAAAAAAAAABgAAAAFHTQAAAAAAAJq7InwKjt5jipNWRwpxF/CrSPRYMGg3ZW8MLMsSUThvAAAAAAX14QAAAAAAAAAAAA==";
      //   try {
      //     print("XDR: $xdr");
      //     final shouldSubmit = true;
      //     final network = "Diamante Testnet";
      //     js.JsObject diam = js.context['diam'];
      //     js.JsObject signResult = diam.callMethod('sign', [xdr, shouldSubmit, network]);
      //
      //     // Check if the result is a Promise-like object
      //     if (signResult is js.JsObject && signResult.hasProperty('then')) {
      //       signResult.callMethod('then', [
      //             (result) {
      //           print('Signature result: $result');
      //         }
      //       ]).callMethod('catch', [
      //             (error) {
      //           print('Error signing transaction: $error');
      //         }
      //       ]);
      //     } else {
      //       // If it's not a Promise, assume it's the direct result
      //       print('Signature result: $signResult');
      //     }
      //   } catch (e) {
      //     print("TRANS ${e}");
      //   }
      //   // signTransaction();
      // }),
      // floatingActionButton: FloatingActionButton(onPressed: ()async{
      //   final transactionXdr = await CreateAccount(context).getTrx("GDUJ7O2MRH72ZRGV26RVKM7547O25JAYHOFRZZDYISYM4LNFAEGGUZA7c");
      //   // checkDiamExtension();
      // }, child: Icon(Icons.add, color: Colors.white,),),
      // appBar: AppBar(
      //   title: Text(
      //     '$kName',
      //     style: TextStyle(fontSize: 32),
      //   ),
      //   centerTitle: false,
      //   automaticallyImplyLeading: false,
      //   leading: LottieBuilder.asset('animations/infinity.json'),
      //   actions: [
      //     RichText(text: TextSpan(
      //         style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 24, fontFamily: 'Baloo'),
      //         children: [
      //           TextSpan(text: 'Balance: ', style: TextStyle(color: Colors.black, )),
      //           TextSpan(text: '\$1000', ),
      //         ]
      //     )),
      //     SizedBox(width: 16.0,),
      //   ],
      // ),
      body: screenLoading ? Center(child: LottieBuilder.asset('animations/infinity.json', height: 200, width: 200,),) : SafeArea(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 8.0,),
                            LottieBuilder.asset('animations/logo.json', height: 30, width: 30,),
                            SizedBox(width: 0.0,),
                            Text(
                              'iam Flow',
                              style: TextStyle(fontSize: 40),
                            ),
                            Spacer(),
                            Container(
                              child: Row(
                                children: [
                                  InkWell(child: Text('Home', style: TextStyle(color: (navText == 'home' ? kPrimaryColor : homeColor), fontWeight: FontWeight.bold, fontSize: 18),), onHover: (value){
                                    print(value);
                                    setState(() {
                                      if(value)
                                        homeColor = kPrimaryColor;
                                      else
                                        homeColor = Colors.black;
                                    });
                                  }, onTap: (){
                                    setState(() {
                                      navText = 'home';
                                      content = HomeTab(pKey: pKey, role: widget.role, transList: transList,);
                                    });
                                  }, hoverColor: Colors.transparent),
                                  SizedBox(width: 24.0,),
                                  InkWell(child: Text('View Transactions', style: TextStyle(color: (navText == 'view-transaction' ? kPrimaryColor : tranColor), fontWeight: FontWeight.bold, fontSize: 18),), onHover: (value){
                                    print(value);
                                    setState(() {
                                      if(value)
                                        tranColor = kPrimaryColor;
                                      else
                                        tranColor = Colors.black;
                                    });
                                  }, onTap: (){
                                    setState(() {
                                      navText = 'view-transaction';
                                      content = ViewTransactionTab();
                                    });
                                  }, hoverColor: Colors.transparent),
                                  SizedBox(width: 24.0,),
                                  InkWell(child: Text('About us', style: TextStyle(color: aboutColor, fontWeight: FontWeight.bold, fontSize: 18),), onHover: (value){
                                    print(value);
                                    setState(() {
                                      if(value)
                                        aboutColor = kPrimaryColor;
                                      else
                                        aboutColor = Colors.black;
                                    });
                                  }, onTap: (){
                                    setState(() {
                                      navText = 'about-us';
                                    });
                                  }, hoverColor: Colors.transparent),
                                  SizedBox(width: 24.0,),
                                  InkWell(child: Text('Help', style: TextStyle(color: helpColor, fontWeight: FontWeight.bold, fontSize: 18),), onHover: (value){
                                    print(value);
                                    setState(() {
                                      if(value)
                                        helpColor = kPrimaryColor;
                                      else
                                        helpColor = Colors.black;
                                    });
                                  }, onTap: (){
                                    setState(() {
                                      navText = 'help';
                                    });
                                  }, hoverColor: Colors.transparent),
                                ],
                              ),
                            ),
                            Spacer(),
                            RichText(text: TextSpan(
                                style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 24, fontFamily: 'Baloo'),
                                children: [
                                  TextSpan(text: 'Balance: ', style: TextStyle(color: Colors.black, )),
                                  TextSpan(text: '100 Diams', ),
                                ]
                            )),
                            SizedBox(width: 8.0,),
                          ],
                        ),
                      ),
                      HomeTab(pKey: pKey, role: widget.role, transList: transList),
                    ],
                  ),
                ),
              ),
            ),
            // Positioned(
            //   bottom: 20,
            //   right: 20,
            //   child: InkWell(
            //     onTap: (){
            //
            //     },
            //     child: Material(
            //       borderRadius: BorderRadius.circular(12),
            //       elevation: 4,
            //       child: Container(
            //         height: 50,
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Row(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Icon(
            //                 Icons.add,
            //                 color: Colors.white,
            //               ),
            //               SizedBox(
            //                 width: 8.0,
            //               ),
            //               Text(
            //                 'Add Account',
            //                 style: TextStyle(
            //                     color: Colors.white, fontWeight: FontWeight.bold),
            //               ),
            //             ],
            //           ),
            //         ),
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(12),
            //             color: kPrimaryColor),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        // child: Center(
        //   child: InkWell(child: Text('SIGN'), onTap: (){
        //     signTransaction();
        //   },),
        // ),
      ),
    );
  }
}
