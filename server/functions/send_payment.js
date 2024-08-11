const express = require('express');
var DiamSdk = require("diamante-sdk-js");
var fetch = require("node-fetch");
const paymentRouter = express.Router();
const { Asset } = require('diamante-sdk-js');
const {TransactionBuilder} = require('diamante-sdk-js');
const {Keypair} = require('diamante-sdk-js');
const {BASE_FEE} = require('diamante-sdk-js');
const {Aurora} = require('diamante-sdk-js');
const {Server} = require('diamante-sdk-js');
const {Operation} = require('diamante-sdk-js');
const { Resolver } = require('diamante-sdk-js/lib/stellartoml');

//source secret account = SAUNVMEY5TOYOGQKH63V4IFCKZNHSKTM5VBPSH6XWUE44F4UAVTMQCSY
//source account = GA2JXIMKVSGPAKK53MFHY3YBQYIMDY6P77W4F35TFFCR3EJPUNBMWJUO
//desintaion account = GDA2RMC5O5GTEUB654ZKAE7K2JMTDVP4QYCLM6BBWXOUBA2FHKPLY47W
//desintation account = 
//
//sendPayment('18', 'Hello there from Rounak', 'GAP6DRIHKH3A3QUQ7HG4IXCRRU654RGN54TLHXTHUINWNLHZHSCTWBAR', 'SBXR47PLRQIHWIWMR6SW62CGMPF2TULBWPI6VV56DSLAD55EGVTLNJ2R');
async function sendPayment(res, childPublicKey, amount, userPublicKey, assetName, userSecretKey){

        var amount = Buffer.from(amount, 'utf8').toString();
        var assetName = Buffer.from(assetName, 'utf8').toString();
        var receivingKeys = Buffer.from(userPublicKey, 'utf8').toString();
        var issuerKeys = Buffer.from(childPublicKey, 'utf8').toString();
        var receiverSecretKey = Buffer.from(userSecretKey, 'utf8').toString();
        console.log("Reached" + issuerKeys);
        var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io/");

// Keys for accounts to issue and receive the new asset
// var issuer = DiamSdk.Keypair.fromSecret(
//   issuerKeySecret
// );
var receiver = DiamSdk.Keypair.fromSecret(
  receiverSecretKey
);

// Create an object to represent the new asset
var astroDollar = new DiamSdk.Asset(assetName, "GAY2GDKZQ7SYTLALFDF4UKRY5DZ5WPKMQRAPEGDAYRIWJLVVOGETTVG5");

// First, the receiving account must trust the asset
server
  .loadAccount(receivingKeys)
  .then(function (receiver) {
    var transaction = new DiamSdk.TransactionBuilder(receiver, {
      fee: 100,
      networkPassphrase: DiamSdk.Networks.TESTNET,
    })
      // The `changeTrust` operation creates (or alters) a trustline
      // The `limit` parameter below is optional
      .addOperation(
        DiamSdk.Operation.changeTrust({
          asset: astroDollar,
          limit: "10000",
        })
      )
      // setTimeout is required for a transaction
      .setTimeout(100)
      .build();
    transaction.sign(receiver);
    return server.submitTransaction(transaction);
  })
  .then(console.log)

  // Second, the issuing account actually sends a payment using the asset
  .then(function () {
    return server.loadAccount("GAY2GDKZQ7SYTLALFDF4UKRY5DZ5WPKMQRAPEGDAYRIWJLVVOGETTVG5");
  })
  .then(function (issuer) {
    var transaction = new DiamSdk.TransactionBuilder(issuer, {
      fee: 100,
      networkPassphrase: DiamSdk.Networks.TESTNET,
    })
      .addOperation(
        DiamSdk.Operation.payment({
          destination: receivingKeys,
          asset: astroDollar,
          amount: "10",
        })
      )
      // setTimeout is required for a transaction
      .setTimeout(100)
      .build();
      var xdr = transaction.toEnvelope().toXDR('base64');
      return res.json({"text" : xdr});
    // transaction.sign(issuingKeys);
    // return server.submitTransaction(transaction);
  })
  .then(console.log)
  .catch(function (error) {
    console.error("Error!", error);
    return res.json({"error": error});
  });
}

async function sendPaymentToWorker(res, parentPublicKey, amount, workerPublicKey, assetName){

        var amount = Buffer.from(amount, 'utf8').toString();;
        var destinationId = Buffer.from(workerPublicKey, 'utf8').toString();
        var sourceSecretKey = Buffer.from(parentPublicKey, 'utf8').toString();
        assetName = Buffer.from(assetName, 'utf8').toString();
        console.log("source: "+sourceSecretKey);
        console.log("Reached");
        var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");
        const sourceAccount = await server.loadAccount(sourceSecretKey)
        //constructing the transaction
        const _asset = new Asset(
          assetName,
          sourceSecretKey //distributor //"GA3SXDTF26ERV3ZVPH3NG7AGWX772JZCNEOFFZR2EFEH57LI3XZO7OUF"//CHILD ACCOUNT
      );
        var transaction = new DiamSdk.TransactionBuilder(sourceAccount, {
          fee: DiamSdk.BASE_FEE,
          networkPassphrase: DiamSdk.Networks.TESTNET,
        })
          //adding payment operations to transfer
          .addOperation(
            DiamSdk.Operation.payment({
              destination: destinationId, //
              asset: _asset,
              amount: amount.toString(),
            })
          )
          .setTimeout(0)
          .build();
        //extracting the transaction XDR to pass it to extension
        var xdr = transaction.toEnvelope().toXDR('base64');
        console.log(xdr);
        return res.json({"text" : xdr});
        //var destinationId = "GC4ZJJRESNHECNST6HA5HUBYAUUGETMKGESJMEKYQLYBCQXTLYNVCUY7";
        // Transaction will hold a built transaction we can resubmit if the result is unknown.
        var transaction;
      //   const _asset = new Asset(
      //     assetName,
      //     sourceKeys.publicKey(), //issuer
      // );
        // First, check to make sure that the destination account exists.
        // You could skip this, but if the account does not exist, you will be charged
        // the transaction fee when the transaction fails.

        server
          .loadAccount(destinationId)
          // If the account is not found, surface a nicer error message for logging.
          .catch(function (error) {
            if (error instanceof DiamSdk.NotFoundError) {
              throw new Error("The destination account does not exist!");
            } else return error;
          })
          // If there was no error, load up-to-date information on your account.
          .then(function () {
            return server.loadAccount(destinationId);
          })
          .then(function (sourceAccount) {
            // Start building the transaction.
            transaction = new DiamSdk.TransactionBuilder(sourceAccount, {
              fee: DiamSdk.BASE_FEE,
              networkPassphrase: DiamSdk.Networks.TESTNET,
            })
              .addOperation(
                DiamSdk.Operation.payment({
                  destination: destinationId,
                  // Because Diamante allows transaction in many currencies, you must
                  // specify the asset type. The special "native" asset represents Lumens.
                  asset: DiamSdk.Asset.native(),
                  //asset: _asset
                  amount: amount,
                })
              )
              // A memo allows you to add your own metadata to a transaction. It's
              // optional and does not affect how Diamante treats the transaction.
              .addMemo(DiamSdk.Memo.text("memo"))
              // Wait a maximum of three minutes for the transaction
              .setTimeout(180)
              .build();
            // Sign the transaction to prove you are actually the person sending it.
            // transaction.sign(sourceKeys);
            // And finally, send it off to Diamante!
            return res.json({"text" : transaction.toEnvelope().toXDR('base64')});
          })
          .then(function (result) {
            console.log("Success! Results:", result);
            return res.json(result);
          })
          .catch(function (error) {
            console.error("Something went wrong!", error);
            return res.json(error);
            // If the result is unknown (no response body, timeout etc.) we simply resubmit
            // already built transaction:
            // server.submitTransaction(transaction);
          });
}

async function sendPaymentToContractor(res, parentPublicKey, amount, contractorPublicKey, assetName){

  var amount = Buffer.from(amount, 'utf8').toString();;
  var destinationId = Buffer.from(contractorPublicKey, 'utf8').toString();
  var sourceSecretKey = Buffer.from(parentPublicKey, 'utf8').toString();
  var assetName = Buffer.from(assetName, 'utf8').toString();
  console.log("source: "+sourceSecretKey);
  console.log("Reached");

  const _asset = new Asset(
    assetName,
    sourceSecretKey //distributor //"GA3SXDTF26ERV3ZVPH3NG7AGWX772JZCNEOFFZR2EFEH57LI3XZO7OUF"//CHILD ACCOUNT
);

  var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");
  const sourceAccount = await server.loadAccount(sourceSecretKey)
  //constructing the transaction
  var transaction = new DiamSdk.TransactionBuilder(sourceAccount, {
    fee: DiamSdk.BASE_FEE,
    networkPassphrase: DiamSdk.Networks.TESTNET,
  })
    //adding payment operations to transfer
    .addOperation(
      DiamSdk.Operation.payment({
        destination: destinationId, //
        asset: _asset,
        amount: amount.toString(),
      })
    )
    .setTimeout(0)
    .build();
  //extracting the transaction XDR to pass it to extension
  var xdr = transaction.toEnvelope().toXDR('base64');
  console.log(xdr);
  return res.json({"text" : xdr});
  //var destinationId = "GC4ZJJRESNHECNST6HA5HUBYAUUGETMKGESJMEKYQLYBCQXTLYNVCUY7";
  // Transaction will hold a built transaction we can resubmit if the result is unknown.
  var transaction;
//   const _asset = new Asset(
//     assetName,
//     sourceKeys.publicKey(), //issuer
// );
  // First, check to make sure that the destination account exists.
  // You could skip this, but if the account does not exist, you will be charged
  // the transaction fee when the transaction fails.

  server
    .loadAccount(destinationId)
    // If the account is not found, surface a nicer error message for logging.
    .catch(function (error) {
      if (error instanceof DiamSdk.NotFoundError) {
        throw new Error("The destination account does not exist!");
      } else return error;
    })
    // If there was no error, load up-to-date information on your account.
    .then(function () {
      return server.loadAccount(destinationId);
    })
    .then(function (sourceAccount) {
      // Start building the transaction.
      transaction = new DiamSdk.TransactionBuilder(sourceAccount, {
        fee: DiamSdk.BASE_FEE,
        networkPassphrase: DiamSdk.Networks.TESTNET,
      })
        .addOperation(
          DiamSdk.Operation.payment({
            destination: destinationId,
            // Because Diamante allows transaction in many currencies, you must
            // specify the asset type. The special "native" asset represents Lumens.
            asset: DiamSdk.Asset.native(),
            //asset: _asset
            amount: amount,
          })
        )
        // A memo allows you to add your own metadata to a transaction. It's
        // optional and does not affect how Diamante treats the transaction.
        .addMemo(DiamSdk.Memo.text("memo"))
        // Wait a maximum of three minutes for the transaction
        .setTimeout(180)
        .build();
      // Sign the transaction to prove you are actually the person sending it.
      // transaction.sign(sourceKeys);
      // And finally, send it off to Diamante!
      return res.json({"text" : transaction.toEnvelope().toXDR('base64')});
    })
    .then(function (result) {
      console.log("Success! Results:", result);
      return res.json(result);
    })
    .catch(function (error) {
      console.error("Something went wrong!", error);
      return res.json(error);
      // If the result is unknown (no response body, timeout etc.) we simply resubmit
      // already built transaction:
      // server.submitTransaction(transaction);
    });
}

paymentRouter.post('/send-payment-to-worker', async (req, res) => {
  try{
    const {parentPublicKey, amount, workerPublicKey, assetName} = req.body;
    await sendPaymentToWorker(res, parentPublicKey, amount, workerPublicKey, assetName);
  }catch(e){
    console.log(e);
  }
});

paymentRouter.post('/send-payment-to-contractor', async (req, res) => {
  try{
    const {parentPublicKey, amount, contractorPublicKey, assetName} = req.body;
    await sendPaymentToContractor(res, parentPublicKey, amount, contractorPublicKey, assetName);
  }catch(e){
    console.log(e);
  }
});

paymentRouter.post('/send-payment', async (req, res) => {
    try{
      const {childPublicKey, amount, userPublicKey, assetName, userSecretKey} = req.body;
      await sendPayment(res, childPublicKey, amount, userPublicKey, assetName, userSecretKey);
    }catch(e){
      console.log(e);
    }
});

//recPayment();

async function recPayment(res, accountPublicKey) {
  var accountId = Buffer.from(accountPublicKey, 'utf8').toString();;
  return new Promise((resolve, reject) => {
    var paymentList = [];
    var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");
    //var accountId = "GAP6DRIHKH3A3QUQ7HG4IXCRRU654RGN54TLHXTHUINWNLHZHSCTWBAR";

    // Create an API call to query payments involving the account.
    var payments = server.payments().forAccount(accountId);

    var lastToken = loadLastPagingToken();
    if (lastToken) {
      payments.cursor(lastToken);
    }

    let streamEnded = false;
    let timer = setTimeout(() => {
      streamEnded = true;
      resolve(res.json(paymentList));
    }, 10000); // Wait for 10 seconds before resolving

    payments.stream({
      onmessage: function (payment) {
        if (streamEnded) return;

        savePagingToken(payment.paging_token);

        if (payment.to !== accountId) {
          return;
        }

        var asset;
        if (payment.asset_type === "native") {
          asset = "diam";
        } else {
          asset = payment.asset_code + ":" + payment.asset_issuer;
        }

        paymentList.push({
          'amount': payment.amount,
          'asset': asset,
          'from': payment.from
        });
        console.log(payment.amount + " " + asset + " from " + payment.from);
      },

      onerror: function (error) {
        console.error("Error in payment stream");
        clearTimeout(timer);
        reject(error);
      },
    });
  });
}

function savePagingToken(token) {
  // In most cases, you should save this to a local database or file so that
  // you can load it next time you stream new payments.
}

function loadLastPagingToken() {
  // Get the last paging token from a local database or file
}

paymentRouter.post('/rec-payment', async (req, res) => {
 console.log("Hllo");
  try{
    var list = await recPayment(res, "GAP6DRIHKH3A3QUQ7HG4IXCRRU654RGN54TLHXTHUINWNLHZHSCTWBAR");
    return res.json(list);
  }catch(e){
    
  }
});

module.exports = paymentRouter;