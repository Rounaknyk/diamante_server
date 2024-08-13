import 'dart:convert';

import 'package:diamanteblockchain/class/alert.dart';
import 'package:diamanteblockchain/class/firebase_service.dart';
import 'package:diamanteblockchain/class/format_ket.dart';
import 'package:diamanteblockchain/class/local_data.dart';
import 'package:diamanteblockchain/custom/child_card.dart';
import 'package:diamanteblockchain/custom/dropdown_textfield.dart';
import 'package:diamanteblockchain/custom/transaction_card.dart';
import 'package:diamanteblockchain/custom/worker_card.dart';
import 'package:diamanteblockchain/models/child_model.dart';
import 'package:diamanteblockchain/models/user_model.dart';
import 'package:diamanteblockchain/services/create_account.dart';
import 'package:diamanteblockchain/services/payment_service.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:js' as js;
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import '../class/worker_model.dart';
import '../constants.dart';
import '../custom/custom_button.dart';
import '../custom/icon_textfield.dart';
import '../models/transaction_model.dart';

class HomeTab extends StatefulWidget {
  HomeTab({required this.pKey, required this.role, required this.transList});
  String pKey;
  String role;
  List<TransModel> transList;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {


  String amount1 = '0';
  List<WorkerModel> wmList = [];
  showAddAssetsDialog(Size size) async {
    String assetName = '', amount = '2', publicKey = '';
    publicKey = widget.pKey;
    showDialog(
        context: context,
        builder: (context) {

          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                width: size.width * 0.3,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add Asset',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        IconTextField(
                            hintText: 'Enter asset name',
                            icon: Icons.abc,
                            onChanged: (value) {
                              setState(() {
                                assetName = value;
                              });
                            }),
                        SizedBox(
                          height: 12.0,
                        ),
                        IconTextField(
                            hintText: 'Amount',
                            icon: Icons.money,
                            onChanged: (value) {
                              setState(() {
                                amount = value;
                              });
                            }),
                        SizedBox(
                          height: 12.0,
                        ),
                        IconTextField(
                          hintText: 'Enter public key',
                          icon: Icons.key,
                          onChanged: (value) {
                            setState(() {
                              publicKey = value;
                            });
                          },
                          isSecured: true,
                          inputValue: publicKey,
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        CustomButton(
                            text: 'ADD',
                            backgroundColor: kPrimaryColor,
                            onPressed: () async {
                              await mintAssets(assetName, amount, widget.pKey, childPublicKey);
                              Navigator.pop(context);
                              // await CreateAccount(context).mint();
                            }),
                      ],
                    ),
                    Positioned(
                      child: InkWell(
                        child: Icon(
                          Icons.cancel,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      right: 0,
                      top: 0,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  // sendAssets(userPublicKey, amount, childPublicKey, assetName) async {
  //   var res = await PaymentServices(context).sendAssets(userPublicKey!, amount, childPublicKey, assetName);
  // }

  showAddAccount(Size size) async {
    String assetName = 'default';
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                width: size.width * 0.3,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add Account',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        IconTextField(
                            hintText: 'Enter asset name',
                            icon: Icons.abc,
                            onChanged: (value) {
                              setState(() {
                                assetName = value;
                              });
                            }),
                        SizedBox(
                          height: 12.0,
                        ),
                        signLoading ? LottieBuilder.asset('animations/infinity.json', height: 30, width: 30,) : CustomButton(
                            text: signLoading ? 'LOADING' : 'SIGN',
                            backgroundColor: kPrimaryColor,
                            onPressed: () async {
                              setState(() {
                                signLoading = true;
                              });
                              await signTransaction(assetName);
                              setState(() {
                                signLoading = false;
                              });
                            }),
                      ],
                    ),
                    Positioned(
                      child: InkWell(
                        child: Icon(
                          Icons.cancel,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      right: 0,
                      top: 0,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
  showAddWorkers(Size size) async {

    String workerName = '', workerPublicKey = '', workerBalance = '0';
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                width: size.width * 0.3,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add Worker',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        IconTextField(
                            hintText: 'Enter worker name',
                            icon: Icons.abc,
                            onChanged: (value) {
                              setState(() {
                                workerName = value;
                              });
                            }),
                        SizedBox(
                          height: 12.0,
                        ),
                        IconTextField(
                            hintText: 'Enter public key',
                            icon: Icons.key,
                            isSecured: true,
                            onChanged: (value) {
                              setState(() {
                                workerPublicKey = value;
                              });
                            },),
                        SizedBox(
                          height: 12.0,
                        ),
                        CustomButton(
                            text: 'SIGN',
                            backgroundColor: kPrimaryColor,
                            onPressed: () {
                              setState(() {
                                wmList.add(WorkerModel(publicKey: workerPublicKey, name: workerName));
                              });
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                    Positioned(
                      child: InkWell(
                        child: Icon(
                          Icons.cancel,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      right: 0,
                      top: 0,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  // showSendAssetDialog(Size size, assetName) async {
  //   String amount = '2.02';
  //   UserModel? um;
  //
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Material(
  //           color: Colors.transparent,
  //           child: Center(
  //             child: Container(
  //               padding: EdgeInsets.all(16.0),
  //               width: size.width * 0.3,
  //               decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(12)),
  //               child: Stack(
  //                 children: [
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Text(
  //                         'Send Assets',
  //                         style: TextStyle(
  //                             fontSize: 24,
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                       SizedBox(
  //                         height: 12.0,
  //                       ),
  //                       Text('To: ', style: TextStyle(fontWeight: FontWeight.bold),),
  //                       SizedBox(height: 4.0),
  //                       Container(
  //                         height: 50,
  //                         width: double.infinity,
  //                         child: TextDropdown(title: 'Enter username', list: umList.map((element){
  //                           return DropDownValueModel(name: element!.name, value: element);
  //                         }).toList(), onChanged: (val){
  //                           print("VALUE OF DROPDOWN: ${val.value}");
  //                           setState(() {
  //                             um = val.value;
  //                           });
  //                         },),
  //                       ),
  //                       // IconTextField(
  //                       //     hintText: 'Enter user name',
  //                       //     icon: Icons.abc,
  //                       //     onChanged: (value) {}),
  //                       SizedBox(
  //                         height: 12.0,
  //                       ),
  //                       Text('Amount: ', style: TextStyle(fontWeight: FontWeight.bold),),
  //                       SizedBox(height: 4.0),
  //                       IconTextField(
  //                           hintText: 'Amount',
  //                           icon: Icons.money,
  //                           onChanged: (value) {}),
  //                       SizedBox(
  //                         height: 12.0,
  //                       ),
  //                       CustomButton(
  //                           text: 'SEND',
  //                           backgroundColor: kPrimaryColor,
  //                           onPressed: () {
  //                             sendAssets(um!.publicKey, amount, childPublicKey, 'assetName');
  //                           }),
  //                     ],
  //                   ),
  //                   Positioned(
  //                     child: InkWell(
  //                       child: Icon(
  //                         Icons.cancel,
  //                       ),
  //                       onTap: () {
  //                         Navigator.pop(context);
  //                       },
  //                     ),
  //                     right: 0,
  //                     top: 0,
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  showSendAssetsToWorkers(Size size) async {
    TextEditingController _eachWorkerController = TextEditingController();
    double amount = 0.0, eachWorkerAmount = 0.0;
    String assetName = 'bridgeGoa';

    showDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                width: size.width * 0.3,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Send payment to workers',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text('Asset name: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 4.0),
                        IconTextField(
                            hintText: 'Asset name',
                            icon: Icons.abc,
                            onChanged: (value) {
                              setState(() {
                                assetName = value;
                              });
                            }),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text('Total amount: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 4.0),
                        IconTextField(
                            hintText: 'Amount',
                            icon: Icons.money,
                            onChanged: (value) {
                              setState(() {
                                amount = double.parse(value);
                                _eachWorkerController.text = (amount / wmList.length).toString();
                                print(_eachWorkerController.text);
                              });
                            }),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text('Each worker will get: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 4.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: _eachWorkerController,
                                decoration: InputDecoration(
                                  focusColor: kPrimaryColor,
                                  border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,), borderRadius: BorderRadius.circular(12)),
                                  hintText: 'Results',
                                  prefixIcon: Icon(
                                    Icons.money,
                                    color: kGrey,
                                  ),
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        CustomButton(
                            text: 'SEND',
                            backgroundColor: kPrimaryColor,
                            onPressed: () async {
                              Navigator.pop(context);
                              for(var worker in wmList){
                                print('sending payment to worker');
                                await sendAssetsToAll(_eachWorkerController.text, worker.publicKey, assetName);
                                print('Done');
                              }
                              // sendAssets(um!.publicKey, amount, childPublicKey, 'assetName');
                            }),
                      ],
                    ),
                    Positioned(
                      child: InkWell(
                        child: Icon(
                          Icons.cancel,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      right: 0,
                      top: 0,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  // Future<dynamic> fetchOpertaions(transactionId) async {
  //   final url = Uri.parse('https://diamtestnet.diamcircle.io/transactions/$transactionId/operations');
  //
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //
  //       var operationType = data['_embedded']['records'][0]['type'];
  //       var funder = data['_embedded']['records'][0]['funder'];
  //       var account = data['_embedded']['records'][0]['account'];
  //       print("Transactions: $operationType");
  //
  //       Map map = {
  //         "operationType": operationType,
  //         "funder" : funder,
  //         "account" : account
  //       };
  //       return map;
  //
  //       // isLoading = false;
  //     } else {
  //
  //       throw Exception('Failed to load transactions');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     return 'None';
  //     setState(() {
  //       // isLoading = false;
  //     });
  //   }
  // }
  //
  //
  // Future<void> fetchTransactions() async {
  //   final url = Uri.parse('https://diamtestnet.diamcircle.io/accounts/${widget.pKey}/transactions');
  //
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       transList = [];
  //       var transactions = data['_embedded']['records'];
  //       for(var trans in transactions){
  //         String funderAcc = '';
  //         String operatioTnype = '';
  //         //         "operationType": operationType,
  //         // "funder" : funder,
  //         // "account" : account
  //         var res = await fetchOpertaions(trans['id']);
  //         print(trans['source_account']);
  //         print(trans['created_at']);
  //         print(res['funder']);
  //         print(res['operationType']);
  //         print(res['account']);
  //         // transList.add(TransModel(source_account: trans['source_account'], create_date: trans['created_at'], funder_account: res['funder'], operationType: res['operationType'], account: res['account']));
  //         transList.add(TransModel(source_account: FormatKey().formatPublicKey(trans['source_account']), create_date: trans['created_at'], funder_account: FormatKey().formatPublicKey(res['funder']), operationType: res['operationType'], account: FormatKey().formatPublicKey(res['account'])));
  //       }
  //       print("Transactions: $transactions");
  //
  //       // isLoading = false;
  //       setState(() {
  //
  //       });
  //     } else {
  //       throw Exception('Failed to load transactions');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     setState(() {
  //       // isLoading = false;
  //     });
  //   }
  // }


  // signTrx() async {
  //   final trx = await CreateAccount(context).getTrx("");
  //   print("TRNS : $trx}");
  // }

  List<ChildModel> childList = [];
  Future mintAssets(String assetName, String amount, String parentPublicKey, String childPublicKey) async {
    print("MINTING");
    print(assetName);
    print(amount);
    print(parentPublicKey);
    print(childPublicKey);
    // if (js.context.hasProperty('diam')) {
    // final transactionXdr;
    try {
      // final transactionXdr = await CreateAccount(context)
      //     .getTrx("GBOGTJ5FNGEVS2ILE7YDZMAWMMOLBBKXKEFHAX3UYYTF6PKQQPMPXIBJ");
      print("THIS IS UR PKEY ${parentPublicKey}");
      final transactionXdr = await CreateAccount(context).mint(assetName, amount, parentPublicKey, childPublicKey);
      print("NSS ${transactionXdr}");
      final shouldSubmit = true;
      final network = "Diamante Testnet";

      print("${transactionXdr} xdr generated");
      try {
        js.JsObject diam = js.context['diam'];
        js.JsObject signResult = diam.callMethod('sign', [transactionXdr, shouldSubmit, network]);

        // Check if the result is a Promise-like object
        if (signResult is js.JsObject && signResult.hasProperty('then')) {
          signResult.callMethod('then', [
                (result) {
              print('Signature result: $result');
            }
          ]).callMethod('catch', [
                (error) {
              print('Error signing transaction: $error');
            }
          ]);
        } else {
          // If it's not a Promise, assume it's the direct result
          print('Signature result: $signResult');
        }
      } catch (e) {
        print('Error calling sign method: $e');
      }
    } catch (e) {
      print("TRANS ${e}");
    }
    // final transactionXdr = "AAAAAgAAAADD9u0l8B7fMgvRITQuplXFfTskVrNgTgyBN1heDfkLEAAAAGQApCseAAAAAQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAQAAAADId5UakWjIgj3XsdYXl/8mJKTpUSUIu8F3IcB7cKoQ1wAAAAAAAAAAAExLQAAAAAAAAAAA";

    // } else {
    //   print("Diam extension is not installed.");
    // }
  }

  String assetName1 = '';
  bool signLoading = false;
  Future signTransaction(assetName) async {
    Alert(context: context).msg('Please wait it might take some time...');
    Toast.show("Please wait for some seconds...", duration: Toast.lengthLong, gravity:  Toast.bottom);
    assetName1 = assetName;
    try {
      print("THIS IS UR PKEY ${widget.pKey}");
      final res = await CreateAccount(context)
          .getTrx(widget.pKey);
      childSecretKey = res['childSecretKey'];
      childPublicKey = res['childPublicKey'];
      LocalData().saveToLocalStorage('childPublicKey', res['childPublicKey']);
      LocalData().saveToLocalStorage('childSecretKey', res['childSecretKey']);
      var transactionXdr = res['text'];
      print(transactionXdr);
      final shouldSubmit = true;
      final network = "Diamante Testnet";

      // print("${transactionXdr} xdr generated");
      try {
        js.JsObject diam = js.context['diam'];
        js.JsObject signResult = diam.callMethod('sign', [transactionXdr, shouldSubmit, network]);

        // Check if the result is a Promise-like object
        if (signResult is js.JsObject && signResult.hasProperty('then')) {
          signResult.callMethod('then', [
                (result) {
              print('Signature result: $result');
            }
          ]).callMethod('catch', [
                (error) {
              print('Error signing transaction: $error');
            }
          ]);
        } else {
          // If it's not a Promise, assume it's the direct result
          print('Signature result: $signResult');
        }
      } catch (e) {
        print('Error calling sign method: $e');
      }
    } catch (e) {
      print("TRANS ${e}");
    }
    // final transactionXdr = "AAAAAgAAAADD9u0l8B7fMgvRITQuplXFfTskVrNgTgyBN1heDfkLEAAAAGQApCseAAAAAQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAQAAAADId5UakWjIgj3XsdYXl/8mJKTpUSUIu8F3IcB7cKoQ1wAAAAAAAAAAAExLQAAAAAAAAAAA";

    // } else {
    //   print("Diam extension is not installed.");
    // }

    childList.add(ChildModel(id: '1', childPublicKey: childPublicKey, assetName: assetName, childSecretKey: childSecretKey, balance: '$amount1', parentPubicKey: widget.pKey));
    Navigator.pop(context);
  }

  String parentSecretKey = '', childSecretKey = '', childPublicKey = '';

  List<WorkerModel> workerList = [
    WorkerModel(publicKey: 'GDEMCFFMOPTSEFO6S266FM2TWQVKVN2RZLHIQKAUFHDLRMZ2NZORJI3G', name: 'Nishchal Naik'),
    WorkerModel(publicKey: 'GALLKZTRWGQUODJ3OYYSSYIOCDVZMDEY3F7VW7XABEP4TBNYYRFAMN4P', name: 'Shridhar Kamat'),
    WorkerModel(publicKey: 'GCV3YSLC5ICG4JRGCREF6N3IQRESRAGZIO5GXLFF3HMUQREGSLBJTPNM', name: 'Rounak Naik'),
    WorkerModel(publicKey: 'GDBU2V4J2RUR537BE4S6PVJYYJNMQKZRHX7ESYFIB4BXGI3NILOYWT75', name: 'Sanjay Kumar'),
  ];

  bool screenLoading = false;

  bool dotLoading = false;

  sendAssetsToAll(amount, workerPublicKey, assetName) async {
    setState(() {
      dotLoading = true;
    });
    try {
      print("Worker: $workerPublicKey");
      print("Amount: $amount");
      print('KEY: ${widget.pKey}');
      print('ASSET: $assetName');
      var transactionXdr = await PaymentServices(context).sendPaymentToWorker(
          widget.pKey, amount, workerPublicKey, assetName);
      final shouldSubmit = true;
      final network = "Diamante Testnet";

      // print("${transactionXdr} xdr generated");
      try {
        js.JsObject diam = js.context['diam'];
        js.JsObject signResult = diam.callMethod(
            'sign', [transactionXdr, shouldSubmit, network]);

        // Check if the result is a Promise-like object
        if (signResult is js.JsObject && signResult.hasProperty('then')) {
          signResult.callMethod('then', [
                (result) {
              print('Signature result: $result');
            }
          ]).callMethod('catch', [
                (error) {
              print('Error signing transaction: $error');
            }
          ]);
        } else {
          // If it's not a Promise, assume it's the direct result
          print('Signature result: $signResult');
        }
      } catch (e) {
        print('Error calling sign method: $e');
      }
    }catch(e){
      print("PAYMENT ERROR: $e");
    }
    setState(() {
      dotLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getKeys();
    print(widget.role);

    // getUsers();
    // getTrans();

  }

  // getTrans() async {
  //   setState(() {
  //     screenLoading = true;
  //   });
  //   await fetchTransactions();
  //   print('LENGTH ${transList.length}');
  //   setState(() {
  //     screenLoading = false;
  //   });
  // }
  getKeys() async {
    setState(() {
      screenLoading = true;
    });
    // var parentSecretKey = await LocalData().loadStoredValue('secretKey');
    // print("THIS IS PARENT KEY $parentSecretKey");

    try {
      childSecretKey = await LocalData().loadStoredValue('childSecretKey');
      childPublicKey = await LocalData().loadStoredValue('childPublicKey');
      print("PARENNTTT ${LocalData().loadStoredValue('parentPublicKey')}");
      print("THIS IS CHILD S KEY $childSecretKey");
      print("THIS IS CHILD P KEY $childPublicKey");

    }catch(e){
      childSecretKey = '';
      // Alert(context: context).alert('Error getting child key');
    }
    setState(() {
      screenLoading = false;
    });
  }

  List<UserModel> umList = [];

  // getUsers() async {
  //   umList = await FirebaseService().getAllUsers();
  //   print(umList.length);
  //   setState(() {
  //
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.role == 'government' ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  showAddAccount(size);
                },
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 250,
                    width: 230,
                    padding:
                    EdgeInsets.symmetric(vertical: 50.0, horizontal: 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kPrimaryColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          'Add account',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ) : Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  showAddWorkers(size);
                },
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 250,
                    width: 230,
                    padding:
                    EdgeInsets.symmetric(vertical: 50.0, horizontal: 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kPrimaryColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          'Add Workers',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            widget.role == 'contractor' ? Container(
              height: 300,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: wmList.map((element){

                  return WorkerCard(wm: element, childSecretKey: childSecretKey, parentPublicKey: widget.pKey, childPublicKey: childPublicKey, role: widget.role, isLoading: dotLoading);
                }).toList(),
              ),
            ) : childList.isEmpty ? Container() : ChildCard(cm: childList[0], childSecretKey: childList[0].childSecretKey, parentPublicKey: childList[0].parentPubicKey, childPublicKey: childPublicKey, role: widget.role, assetName: assetName1)
            // widget.role == 'government' ? (childList.isEmpty ? Container() : ChildCard(cm: childList[0], childSecretKey: childList[0].childSecretKey, parentPublicKey: childList[0].parentPubicKey, childPublicKey: childPublicKey, role: widget.role) ) : workerList.map((element){
            //
            //   return WorkerCard(wm: element, childSecretKey: childSecretKey, parentPublicKey: parentPublicKey, childPublicKey: childPublicKey, role: role);
            // }).toList(),
    // ChildCard(cm: ChildModel(childPublicKey: childPublicKey, assetName: 'bridgeGoa', childSecretKey: childSecretKey, balance: '1800', parentPubicKey: widget.pKey, id: '1'), childSecretKey: childSecretKey, parentPublicKey: widget.pKey, childPublicKey: childPublicKey, role: widget.role),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   'Send assets',
              //   style: TextStyle(
              //       fontSize: 32,
              //       color: Colors.black,
              //       fontWeight: FontWeight.bold),
              // ),
              // SizedBox(
              //   height: 4.0,
              // ),
              // InkWell(
              //   onTap: () {
              //     showSendAssetDialog(size, 'assetName');
              //     // onPressed();
              //   },
              //   child: Container(
              //     width: 150,
              //     height: 40,
              //     decoration: BoxDecoration(
              //         color: kPrimaryColor,
              //         borderRadius: BorderRadius.circular(16)),
              //     child: Center(
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             Text(
              //               'SEND ASSETS',
              //               style: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.white,
              //                   fontSize: 14),
              //             ),
              //             SizedBox(width: 8.0,),
              //             Icon(
              //               Icons.arrow_forward,
              //               color: Colors.white,
              //             )
              //           ],
              //         )),
              //   ),
              // ),
              // SizedBox(
              //   height: 12.0,
              // ),
              // Text('${widget.pKey}'),
              // Text('Lorem ipsum dolor sit amet consectetur adipisicing elit. Voluptatibus, voluptates.\nQui ratione aspernatur tempore incidunt alias, aperiam \naccusamus ullam natus?'),
              Visibility(
                visible: widget.role == 'contractor',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send Assets',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('Send assets to everyone listed in your account with one click!', style: TextStyle(fontSize: 16),),
                    SizedBox(
                      height: 8.0,
                    ),
                    InkWell(
                      onTap: (){
                        // sendAssetsToAll();
                        showSendAssetsToWorkers(size);
                      },
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: kPrimaryColor),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Send Assets', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),),
                              SizedBox(width: 8.0,),
                              Icon(Icons.arrow_forward, color: Colors.white,)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
              ),
              Text(
                'Transactions',
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8.0,
              ),
              Column(
                children: widget.transList.map((element) {

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TransactionCard(tm: element),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ],
    );
  }
}