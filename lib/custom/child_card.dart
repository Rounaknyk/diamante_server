import 'package:diamanteblockchain/models/child_model.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../class/local_data.dart';
import '../constants.dart';
import '../models/user_model.dart';
import '../services/create_account.dart';
import '../services/payment_service.dart';
import 'custom_button.dart';
import 'dropdown_textfield.dart';
import 'icon_textfield.dart';
import 'dart:js' as js;

class ChildCard extends StatefulWidget {
  ChildCard({required this.cm, required this.childSecretKey, required this.parentPublicKey, required this.childPublicKey, required this.role, required this.assetName});
  ChildModel cm;
  String childSecretKey;
  String parentPublicKey;
  String childPublicKey;
  String role;
  String assetName;

  @override
  State<ChildCard> createState() => _ChildCardState();
}

class _ChildCardState extends State<ChildCard> {

  List<UserModel?> umList = [
    UserModel(name: 'Select someone', publicKey: 'publicKey', email: 'email', role: 'role'),
    UserModel(name: 'Ambhuja Cement', publicKey: 'GAY2GDKZQ7SYTLALFDF4UKRY5DZ5WPKMQRAPEGDAYRIWJLVVOGETTVG5', email: 'ambhuja@gmail.com', role: 'contractor', privateKey: "SAXKONYNROWBXN5UQMUFJWLFSTXAV5HBFQQHV7F6LZ2VJPAKIRZP4F6R"),
  ];

  bool trust = false;
  createTrust(assetName) async {
    try {
      // setState(() {
      //   trust = true;
      // });

      print("HIIIII");
      print("SECRETTTT : ${LocalData().loadStoredValue('childSecretKey')}");
      print("CHILD PUBLIC: ${widget.childPublicKey}");
      print("PARENT PUBLIC: ${widget.parentPublicKey}");
      var xdr = await CreateAccount(context).createTrust(assetName, widget.parentPublicKey, widget.childPublicKey);

      // var xdr = await CreateAccount(context).createTrust("widget.pKey", "SDCQ3Q24EBNBQWVAQNB5J2TSFS7JKAKNK67EHPZIJRXEWIJPP2KJSAHQ");
      // var xdr = "AAAAAgAAAABHiHdg9EIPdBsWBSThTs0X374GO62ekwEtfwnj/jGxWwAAAGQAHZCiAAAAAQAAAAEAAAAAAAAAAAAAAABmtIm/AAAAAAAAAAEAAAAAAAAABgAAAAFHTQAAAAAAAJq7InwKjt5jipNWRwpxF/CrSPRYMGg3ZW8MLMsSUThvAAAAAAX14QAAAAAAAAAAAA==";
      try {
        print("XDR: $xdr");
        final shouldSubmit = true;
        final network = "Diamante Testnet";
        js.JsObject diam = js.context['diam'];
        js.JsObject signResult = diam.callMethod('sign', [xdr, shouldSubmit, network]);

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
        print("TRANS ${e}");
      }
      // try {
      //   final shouldSubmit = true;
      //   final network = "Diamante Testnet";
      //   js.JsObject diam = js.context['diam'];
      //   js.JsObject signResult = diam.callMethod('sign', [xdr, shouldSubmit, network]);
      //
      //   // Check if the result is a Promise-like object
      //   if (signResult is js.JsObject && signResult.hasProperty('then')) {
      //     signResult.callMethod('then', [
      //           (result) {
      //         print('Signature result: $result');
      //       }
      //     ]).callMethod('catch', [
      //           (error) {
      //         print('Error signing transaction: $error');
      //       }
      //     ]);
      //   } else {
      //     // If it's not a Promise, assume it's the direct result
      //     print('Signature result: $signResult');
      //   }
      // } catch (e) {
      //   print("TRANS ${e}");
      // }
      setState(() {
        trust = true;
      });
    }catch(e){
      trust = false;
    }
  }

  sendAssets(contractorPublicKey, amount, childPublicKey, assetName) async {
    print("ASSET: ${assetName}");
    print("AMOUNT: ${amount}");
    print("PRAE: ${widget.parentPublicKey}");
    print("CONT: ${contractorPublicKey}");
    var xdr = await PaymentServices(context).sendPaymentToContractor(widget.parentPublicKey, amount, contractorPublicKey, assetName);
    print("NSS ${xdr}");
    final shouldSubmit = true;
    final network = "Diamante Testnet";
try{
    print("${xdr} xdr generated");
    try {
      js.JsObject diam = js.context['diam'];
      js.JsObject signResult = diam.callMethod('sign', [xdr, shouldSubmit, network]);

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
    // var res = await PaymentServices(context).sendAssets(userPublicKey!, amount, widget.childPublicKey, assetName, userPrivateKey);
    Navigator.pop(context);
  }

  void mintAssets(String assetName, String amount, String parentPublicKey, String childPublicKey) async {
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
  String amount1 = '0';
  showAddAssetsDialog(Size size, String assetName) async {
    String assetName = widget.assetName, amount = '2', publicKey = '';
    print("LOD ${publicKey}");
    publicKey = widget.parentPublicKey;
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
                            inputValue: widget.assetName,
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
                                amount1 = amount;
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
                              mintAssets(assetName, amount, publicKey, widget.childPublicKey);
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

  showSendAssetDialog(Size size, assetName) async {
    String amount = '2.02';
    UserModel? um;

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
                          'Send Assets',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text('To: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 4.0),
                        IconTextField(hintText: 'Enter public key', icon: Icons.key, onChanged: (value){
                          setState(() {
                            um = UserModel(name: '', publicKey: value, email: '', role: 'contractor', privateKey: '');
                          });
                        }),
                        // IconTextField(
                        //     hintText: 'Enter user name',
                        //     icon: Icons.abc,
                        //     onChanged: (value) {}),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text('Amount: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 4.0),
                        IconTextField(
                            hintText: 'Amount',
                            icon: Icons.money,
                            onChanged: (value) {
                              amount = value;
                              amount1 = amount;
                            }),
                        SizedBox(
                          height: 12.0,
                        ),
                        CustomButton(
                            text: 'SEND ASSETS',
                            backgroundColor: kPrimaryColor,
                            onPressed: () async {
                              await sendAssets(um!.publicKey, amount, widget.childPublicKey, widget.assetName);
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 230,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
          decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Account ${widget.cm.id}',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  '${widget.cm.childPublicKey}',
                  style: TextStyle(color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 8.0,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.copy,
                          color: kGrey,
                          size: 14,
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          'Copy',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                        child: Divider(
                          height: 2,
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    LottieBuilder.asset(
                      'animations/infinity.json',
                      height: 30,
                      width: 30,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Expanded(
                      child: Container(
                        child: Divider(
                          height: 2,
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Asset: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.cm.assetName}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Balance: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${amount1}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Visibility(
                  visible: !trust,
                  child: SizedBox(
                    height: 8.0,
                  ),
                ),
                Visibility(
                  visible: !trust,
                  child: Container(
                    child: CustomButton(
                      text: 'CREATE TRUST',
                      backgroundColor: kPrimaryColor,
                      onPressed: () {
                        createTrust(widget.cm.assetName);
                        // getUsers();
                        // showAddAssetsDialog(size);
                      },
                    ),
                    height: 40,
                  ),
                ),
                Visibility(
                  visible: trust,
                  child: SizedBox(
                    height: 8.0,
                  ),
                ),
                Visibility(
                  visible: trust,
                  child: Container(
                    child: CustomButton(
                      text: 'ADD ASSETS',
                      backgroundColor: kPrimaryColor,
                      onPressed: () {
                        // getUsers();
                        showAddAssetsDialog(size, widget.cm.assetName);
                      },
                    ),
                    height: 40,
                  ),
                ),
                Visibility(
                  visible: trust,
                  child: SizedBox(
                    height: 8.0,
                  ),
                ),
                Visibility(
                  visible: trust,
                  child: Container(
                    child: CustomButton(
                      text: 'SEND ASSETS',
                      backgroundColor: kPrimaryColor,
                      onPressed: () {
                        // getUsers();
                        showSendAssetDialog(size, widget.cm.assetName);
                        // showAddAssetsDialog(size, widget.cm.assetName);
                      },
                    ),
                    height: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
