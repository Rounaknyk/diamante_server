var DiamSdk = require("diamante-sdk-js");
var fetch = require("node-fetch");
const express = require('express');
const accRouter = require('./functions/create_account');
const paymentRouter = require('./functions/send_payment');
const dataRouter = require('./functions/manage_data');
const assetMinter = require('./functions/asset_minter');
const app = express();
const cors = require('cors');
const bodyParser = require('body-parser');
const DiamanteHDWallet = require('diamante-hd-wallet');
const testRouter = require('./functions/test');

//middlewares
app.use(cors());
app.use(express.json());
app.use(accRouter);
app.use(paymentRouter);
app.use(dataRouter);
app.use(assetMinter);
app.use(testRouter);
app.use(cors({ origin: 'https://diamflow.vercel.app' }));


// create a completely new and unique pair of keys

// Generate a new mnemonic phrase

// Generate a new mnemonic phrase
// const mnemonic = DiamanteHDWallet.generateMnemonic();
// console.log('Mnemonic:', mnemonic);


// const wallet = DiamanteHDWallet.fromMnemonic(mnemonic);

// // Get the public key and secret for the first account (index 0)
// const publicKey = wallet.getPublicKey(0);
// const secret = wallet.getSecret(0);

// const valid = DiamanteHDWallet.fromSeed('later road always ginger material human pyramid veteran normal similar million cave');
// console.log(valid);

// console.log(publicKey);
// console.log(secret);

const port = 3000;
//const serverIp = '192.0.0.2';
// const serverIp = '192.168.102.75';
// const serverIp = '64.71.146.212';


//const dbUrl = process.env.dbUrl;

// const server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io/");

// the JS SDK uses promises for most actions, such as retrieving an account
// dunc();
// async function dunc(){
//     const account = await server.loadAccount("GD3WMY7HHRC7SFXEZB3UBBHNAGSC5WRKAAJKWLJIAA6YM3URCSQS64XE");
// console.log("Balances for account: " + "GD3WMY7HHRC7SFXEZB3UBBHNAGSC5WRKAAJKWLJIAA6YM3URCSQS64XE");
// account.balances.forEach(function (balance) {
//   console.log("Type:", balance.asset_type, ", Balance:", balance.balance);
// });
// }
app.listen(port, () =>{
    console.log("listening");
});
//
//const pair = DiamSdk.Keypair.random();
//
////const publicKey = pair.publicKey();
//const publicKey = "GBWZOZC2NLPUVTAE3M5VPHEDFR7XCY5PL7EQZ7DHOBFQ2IK4M2U5XSD7";
//const secretKey = pair.secret();
//
//console.log(publicKey);
//console.log(secretKey);
//
////deleteData(accountSecretKey, dataName, dataValue);
//
//async function deleteData(accountSecretKey, dataName, dataValue){
//    var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");
//    var sourceKeys = DiamSdk.Keypair.fromSecret(
//      "SCE3MU32ZI3IDCMSC4TKNUCNU4VKVD6HCLZZX2KYQJKG6XADZMRKM4VU"
//    );
//
//    console.log("PUBLIC KEY: "+sourceKeys.publicKey());
//
//    var transaction;
//
//    server
//      .loadAccount(sourceKeys.publicKey())
//      .then(function (sourceAccount) {
//        // Start building the transaction.
//        transaction = new DiamSdk.TransactionBuilder(sourceAccount, {
//          fee: DiamSdk.BASE_FEE,
//          networkPassphrase: "Diamante Testnet",
//        })
//          .addOperation(
//            DiamSdk.Operation.manageData({
//              name: "MyDataEntry", // The name of the data entry
//              value: "", // The value to store
//            })
//          )
//          .setTimeout(0)
//          .build();
//        // Sign the transaction to prove you are actually the person sending it.
//        transaction.sign(sourceKeys);
//        // And finally, send it off to Diamante!
//        return server.submitTransaction(transaction);
//      })
//      .then(function (result) {
//        console.log("Success! Results:", result);
//      })
//      .catch(function (error) {
//        console.error("Something went wrong!", error);
//      });
//}
//
////addData(accountSecretKey, dataName, dataValue);
//
//async function addData(accountSecretKey, dataName, dataValue){
//    var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");
//    var sourceKeys = DiamSdk.Keypair.fromSecret(
//      "SCE3MU32ZI3IDCMSC4TKNUCNU4VKVD6HCLZZX2KYQJKG6XADZMRKM4VU"
//    );
//
//    console.log("PUBLIC KEY: "+sourceKeys.publicKey());
//
//    var transaction;
//
//    server
//      .loadAccount(sourceKeys.publicKey())
//      .then(function (sourceAccount) {
//        // Start building the transaction.
//        transaction = new DiamSdk.TransactionBuilder(sourceAccount, {
//          fee: DiamSdk.BASE_FEE,
//          networkPassphrase: "Diamante Testnet",
//        })
//          .addOperation(
//            DiamSdk.Operation.manageData({
//              name: "MyDataEntry", // The name of the data entry
//              value: "Hello, Diamante!", // The value to store
//            })
//          )
//          .setTimeout(0)
//          .build();
//        // Sign the transaction to prove you are actually the person sending it.
//        transaction.sign(sourceKeys);
//        // And finally, send it off to Diamante!
//        return server.submitTransaction(transaction);
//      })
//      .then(function (result) {
//        console.log("Success! Results:", result);
//      })
//      .catch(function (error) {
//        console.error("Something went wrong!", error);
//      });
//}
//
////RECEIVE PAYMENTS
////recPayment();
//function savePagingToken(token) {
//    // In most cases, you should save this to a local database or file so that
//    // you can load it next time you stream new payments.
//  }
//
//  function loadLastPagingToken() {
//    // Get the last paging token from a local database or file
//  }
//
//async function recPayment(accountPublicKey){
//
//var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");
//var accountId = "GC4ZJJRESNHECNST6HA5HUBYAUUGETMKGESJMEKYQLYBCQXTLYNVCUY7";
//
//// Create an API call to query payments involving the account.
//var payments = server.payments().forAccount(accountId);
//
//// If some payments have already been handled, start the results from the
//// last seen payment. (See below in `handlePayment` where it gets saved.)
//var lastToken = loadLastPagingToken();
//if (lastToken) {
//  payments.cursor(lastToken);
//}
//
//// `stream` will send each recorded payment, one by one, then keep the
//// connection open and continue to send you new payments as they occur.
//payments.stream({
//  onmessage: function (payment) {
//    // Record the paging token so we can start from here next time.
//    savePagingToken(payment.paging_token);
//
//    // The payments stream includes both sent and received payments. We only
//    // want to process received payments here.
//    if (payment.to !== accountId) {
//      return;
//    }
//
//    // In Diamante’s API, Lumens are referred to as the “native” type. Other
//    // asset types have more detailed information.
//    var asset;
//    if (payment.asset_type === "native") {
//      asset = "diam";
//    } else {
//      asset = payment.asset_code + ":" + payment.asset_issuer;
//    }
//
//    console.log(payment.amount + " " + asset + " from " + payment.from);
//  },
//
//  onerror: function (error) {
//    console.error("Error in payment stream");
//  },
//});
//}
//
////SEND PAYMENT
//async function sendPayment(amount, memo, destinationId, sourceSecretKey){
//    var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");
//var sourceKeys = DiamSdk.Keypair.fromSecret(
//  "SD75G4MIKTXGW4KHJCCJ2TVLNIRVN2W5PDIU6A6645XIBZ4EUHKVAQND"
//);
//var destinationId = "GC4ZJJRESNHECNST6HA5HUBYAUUGETMKGESJMEKYQLYBCQXTLYNVCUY7";
//// Transaction will hold a built transaction we can resubmit if the result is unknown.
//var transaction;
//
//// First, check to make sure that the destination account exists.
//// You could skip this, but if the account does not exist, you will be charged
//// the transaction fee when the transaction fails.
//server
//  .loadAccount(destinationId)
//  // If the account is not found, surface a nicer error message for logging.
//  .catch(function (error) {
//    if (error instanceof DiamSdk.NotFoundError) {
//      throw new Error("The destination account does not exist!");
//    } else return error;
//  })
//  // If there was no error, load up-to-date information on your account.
//  .then(function () {
//    return server.loadAccount(sourceKeys.publicKey());
//  })
//  .then(function (sourceAccount) {
//    // Start building the transaction.
//    transaction = new DiamSdk.TransactionBuilder(sourceAccount, {
//      fee: DiamSdk.BASE_FEE,
//      networkPassphrase: DiamSdk.Networks.TESTNET,
//    })
//      .addOperation(
//        DiamSdk.Operation.payment({
//          destination: destinationId,
//          // Because Diamante allows transaction in many currencies, you must
//          // specify the asset type. The special "native" asset represents Lumens.
//          asset: DiamSdk.Asset.native(),
//          amount: "1",
//        })
//      )
//      // A memo allows you to add your own metadata to a transaction. It's
//      // optional and does not affect how Diamante treats the transaction.
//      .addMemo(DiamSdk.Memo.text("Test Transaction"))
//      // Wait a maximum of three minutes for the transaction
//      .setTimeout(180)
//      .build();
//    // Sign the transaction to prove you are actually the person sending it.
//    transaction.sign(sourceKeys);
//    // And finally, send it off to Diamante!
//    return server.submitTransaction(transaction);
//  })
//  .then(function (result) {
//    console.log("Success! Results:", result);
//  })
//  .catch(function (error) {
//    console.error("Something went wrong!", error);
//    // If the result is unknown (no response body, timeout etc.) we simply resubmit
//    // already built transaction:
//    // server.submitTransaction(transaction);
//  });
//}
//
//
////Get Balance of created account
//// the JS SDK uses promises for most actions, such as retrieving an account
//
////getBalance(publicKey);
//async function getBalance(publicKey){
//    const server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io/");
//
//    const account = await server.loadAccount(publicKey);
//    console.log("Balances for account: " + publicKey);
//    account.balances.forEach(function (balance) {
//        console.log("Type:", balance.asset_type, ", Balance:", balance.balance);
//      });
//}
//
//createAccount();
//
//async function createAccount  (){
//    try {
//      const response = await fetch(
//        `https://friendbot.diamcircle.io?addr=${encodeURIComponent(
//          pair.publicKey()
//        )}`
//      );
//      const responseJSON = await response.json();
//      console.log("SUCCESS! You have a new account :)\n", responseJSON);
//    } catch (e) {
//      console.error("ERROR!", e);
//    }
//    // After you've got your test lumens from friendbot, we can also use that account to create a new account on the ledger.
//    try {
//      const server = new DiamSdk.Horizon.Server(
//        "https://diamtestnet.diamcircle.io/"
//      );
//      var parentAccount = await server.loadAccount(pair.publicKey()); //make sure the parent account exists on ledger
//      var childAccount = DiamSdk.Keypair.random(); //generate a random account to create
//      //create a transacion object.
//      var createAccountTx = new DiamSdk.TransactionBuilder(parentAccount, {
//        fee: DiamSdk.BASE_FEE,
//        networkPassphrase: DiamSdk.Networks.TESTNET,
//      });
//      //add the create account operation to the createAccountTx transaction.
//      createAccountTx = await createAccountTx
//        .addOperation(
//          DiamSdk.Operation.createAccount({
//            destination: childAccount.publicKey(),
//            startingBalance: "5",
//          })
//        )
//        .setTimeout(180)
//        .build();
//      //sign the transaction with the account that was created from friendbot.
//      await createAccountTx.sign(pair);
//      //submit the transaction
//      let txResponse = await server
//        .submitTransaction(createAccountTx)
//        // some simple error handling
//        .catch(function (error) {
//          console.log("there was an error");
//          console.log(error.response);
//          console.log(error.status);
//          console.log(error.extras);
//          return error;
//        });
//      console.log(txResponse);
//      console.log("Created the new account", childAccount.publicKey());
//    } catch (e) {
//      console.error("ERROR!", e);
//    }
//  };
//// create a completely new and unique pair of keys
////const pair = DiamSdk.Keypair.random();
//
////const publicKey = pair.publicKey();
////const publicKey = "GBWZOZC2NLPUVTAE3M5VPHEDFR7XCY5PL7EQZ7DHOBFQ2IK4M2U5XSD7";
////const secretKey = pair.secret();
//
//console.log(publicKey);
//console.log(secretKey);
//
////deleteData(accountSecretKey, dataName, dataValue);
//
//async function deleteData(accountSecretKey, dataName, dataValue){
//    var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");
//    var sourceKeys = DiamSdk.Keypair.fromSecret(
//      "SCE3MU32ZI3IDCMSC4TKNUCNU4VKVD6HCLZZX2KYQJKG6XADZMRKM4VU"
//    );
//
//    console.log("PUBLIC KEY: "+sourceKeys.publicKey());
//
//    var transaction;
//
//    server
//      .loadAccount(sourceKeys.publicKey())
//      .then(function (sourceAccount) {
//        // Start building the transaction.
//        transaction = new DiamSdk.TransactionBuilder(sourceAccount, {
//          fee: DiamSdk.BASE_FEE,
//          networkPassphrase: "Diamante Testnet",
//        })
//          .addOperation(
//            DiamSdk.Operation.manageData({
//              name: "MyDataEntry", // The name of the data entry
//              value: "", // The value to store
//            })
//          )
//          .setTimeout(0)
//          .build();
//        // Sign the transaction to prove you are actually the person sending it.
//        transaction.sign(sourceKeys);
//        // And finally, send it off to Diamante!
//        return server.submitTransaction(transaction);
//      })
//      .then(function (result) {
//        console.log("Success! Results:", result);
//      })
//      .catch(function (error) {
//        console.error("Something went wrong!", error);
//      });
//}
//
////addData(accountSecretKey, dataName, dataValue);
//
//async function addData(accountSecretKey, dataName, dataValue){
//    var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");
//    var sourceKeys = DiamSdk.Keypair.fromSecret(
//      "SCE3MU32ZI3IDCMSC4TKNUCNU4VKVD6HCLZZX2KYQJKG6XADZMRKM4VU"
//    );
//
//    console.log("PUBLIC KEY: "+sourceKeys.publicKey());
//
//    var transaction;
//
//    server
//      .loadAccount(sourceKeys.publicKey())
//      .then(function (sourceAccount) {
//        // Start building the transaction.
//        transaction = new DiamSdk.TransactionBuilder(sourceAccount, {
//          fee: DiamSdk.BASE_FEE,
//          networkPassphrase: "Diamante Testnet",
//        })
//          .addOperation(
//            DiamSdk.Operation.manageData({
//              name: "MyDataEntry", // The name of the data entry
//              value: "Hello, Diamante!", // The value to store
//            })
//          )
//          .setTimeout(0)
//          .build();
//        // Sign the transaction to prove you are actually the person sending it.
//        transaction.sign(sourceKeys);
//        // And finally, send it off to Diamante!
//        return server.submitTransaction(transaction);
//      })
//      .then(function (result) {
//        console.log("Success! Results:", result);
//      })
//      .catch(function (error) {
//        console.error("Something went wrong!", error);
//      });
//}
//
////RECEIVE PAYMENTS
////recPayment();
//function savePagingToken(token) {
//    // In most cases, you should save this to a local database or file so that
//    // you can load it next time you stream new payments.
//  }
//
//  function loadLastPagingToken() {
//    // Get the last paging token from a local database or file
//  }
//
//async function recPayment(accountPublicKey){
//
//var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");
//var accountId = "GC4ZJJRESNHECNST6HA5HUBYAUUGETMKGESJMEKYQLYBCQXTLYNVCUY7";
//
//// Create an API call to query payments involving the account.
//var payments = server.payments().forAccount(accountId);
//
//// If some payments have already been handled, start the results from the
//// last seen payment. (See below in `handlePayment` where it gets saved.)
//var lastToken = loadLastPagingToken();
//if (lastToken) {
//  payments.cursor(lastToken);
//}
//
//// `stream` will send each recorded payment, one by one, then keep the
//// connection open and continue to send you new payments as they occur.
//payments.stream({
//  onmessage: function (payment) {
//    // Record the paging token so we can start from here next time.
//    savePagingToken(payment.paging_token);
//
//    // The payments stream includes both sent and received payments. We only
//    // want to process received payments here.
//    if (payment.to !== accountId) {
//      return;
//    }
//
//    // In Diamante’s API, Lumens are referred to as the “native” type. Other
//    // asset types have more detailed information.
//    var asset;
//    if (payment.asset_type === "native") {
//      asset = "diam";
//    } else {
//      asset = payment.asset_code + ":" + payment.asset_issuer;
//    }
//
//    console.log(payment.amount + " " + asset + " from " + payment.from);
//  },
//
//  onerror: function (error) {
//    console.error("Error in payment stream");
//  },
//});
//}
//
////SEND PAYMENT
//async function sendPayment(amount, memo, destinationId, sourceSecretKey){
//    var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");
//var sourceKeys = DiamSdk.Keypair.fromSecret(
//  "SD75G4MIKTXGW4KHJCCJ2TVLNIRVN2W5PDIU6A6645XIBZ4EUHKVAQND"
//);
//var destinationId = "GC4ZJJRESNHECNST6HA5HUBYAUUGETMKGESJMEKYQLYBCQXTLYNVCUY7";
//// Transaction will hold a built transaction we can resubmit if the result is unknown.
//var transaction;
//
//// First, check to make sure that the destination account exists.
//// You could skip this, but if the account does not exist, you will be charged
//// the transaction fee when the transaction fails.
//server
//  .loadAccount(destinationId)
//  // If the account is not found, surface a nicer error message for logging.
//  .catch(function (error) {
//    if (error instanceof DiamSdk.NotFoundError) {
//      throw new Error("The destination account does not exist!");
//    } else return error;
//  })
//  // If there was no error, load up-to-date information on your account.
//  .then(function () {
//    return server.loadAccount(sourceKeys.publicKey());
//  })
//  .then(function (sourceAccount) {
//    // Start building the transaction.
//    transaction = new DiamSdk.TransactionBuilder(sourceAccount, {
//      fee: DiamSdk.BASE_FEE,
//      networkPassphrase: DiamSdk.Networks.TESTNET,
//    })
//      .addOperation(
//        DiamSdk.Operation.payment({
//          destination: destinationId,
//          // Because Diamante allows transaction in many currencies, you must
//          // specify the asset type. The special "native" asset represents Lumens.
//          asset: DiamSdk.Asset.native(),
//          amount: "1",
//        })
//      )
//      // A memo allows you to add your own metadata to a transaction. It's
//      // optional and does not affect how Diamante treats the transaction.
//      .addMemo(DiamSdk.Memo.text("Test Transaction"))
//      // Wait a maximum of three minutes for the transaction
//      .setTimeout(180)
//      .build();
//    // Sign the transaction to prove you are actually the person sending it.
//    transaction.sign(sourceKeys);
//    // And finally, send it off to Diamante!
//    return server.submitTransaction(transaction);
//  })
//  .then(function (result) {
//    console.log("Success! Results:", result);
//  })
//  .catch(function (error) {
//    console.error("Something went wrong!", error);
//    // If the result is unknown (no response body, timeout etc.) we simply resubmit
//    // already built transaction:
//    // server.submitTransaction(transaction);
//  });
//}
//
//
////Get Balance of created account
//// the JS SDK uses promises for most actions, such as retrieving an account
//
////getBalance(publicKey);
//async function getBalance(publicKey){
//    const server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io/");
//
//    const account = await server.loadAccount(publicKey);
//    console.log("Balances for account: " + publicKey);
//    account.balances.forEach(function (balance) {
//        console.log("Type:", balance.asset_type, ", Balance:", balance.balance);
//      });
//}
//
////createAccount();
//
//async function createAccount  (){
//    try {
//      const response = await fetch(
//        `https://friendbot.diamcircle.io?addr=${encodeURIComponent(
//          pair.publicKey()
//        )}`
//      );
//      const responseJSON = await response.json();
//      console.log("SUCCESS! You have a new account :)\n", responseJSON);
//    } catch (e) {
//      console.error("ERROR!", e);
//    }
//    // After you've got your test lumens from friendbot, we can also use that account to create a new account on the ledger.
//    try {
//      const server = new DiamSdk.Horizon.Server(
//        "https://diamtestnet.diamcircle.io/"
//      );
//      var parentAccount = await server.loadAccount(pair.publicKey()); //make sure the parent account exists on ledger
//      var childAccount = DiamSdk.Keypair.random(); //generate a random account to create
//      //create a transacion object.
//      var createAccountTx = new DiamSdk.TransactionBuilder(parentAccount, {
//        fee: DiamSdk.BASE_FEE,
//        networkPassphrase: DiamSdk.Networks.TESTNET,
//      });
//      //add the create account operation to the createAccountTx transaction.
//      createAccountTx = await createAccountTx
//        .addOperation(
//          DiamSdk.Operation.createAccount({
//            destination: childAccount.publicKey(),
//            startingBalance: "5",
//          })
//        )
//        .setTimeout(180)
//        .build();
//      //sign the transaction with the account that was created from friendbot.
//      await createAccountTx.sign(pair);
//      //submit the transaction
//      let txResponse = await server
//        .submitTransaction(createAccountTx)
//        // some simple error handling
//        .catch(function (error) {
//          console.log("there was an error");
//          console.log(error.response);
//          console.log(error.status);
//          console.log(error.extras);
//          return error;
//        });
//      console.log(txResponse);
//      console.log("Created the new account", childAccount.publicKey());
//    } catch (e) {
//      console.error("ERROR!", e);
//    }
//  };
