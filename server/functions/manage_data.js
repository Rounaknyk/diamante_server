const express = require('express');
const dataRouter = express.Router();
var DiamSdk = require("diamante-sdk-js");
var fetch = require("node-fetch");

async function addData(res){
    console.log("DATAAA");
    var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");

    var sourceKeys = DiamSdk.Keypair.fromSecret(
        "SCE3MU32ZI3IDCMSC4TKNUCNU4VKVD6HCLZZX2KYQJKG6XADZMRKM4VU"
      );
      
      var transaction;
      
      server
        .loadAccount(sourceKeys.publicKey())
        .then(function (sourceAccount) {
          // Start building the transaction.
          transaction = new DiamSdk.TransactionBuilder(sourceAccount, {
            fee: DiamSdk.BASE_FEE,
            networkPassphrase: "Diamante Testnet",
          })
            .addOperation(
              DiamSdk.Operation.manageData({
                name: "Hello Guyssss", // The name of the data entry
                value: "Hello, Diamante!!!!", // The value to store
              })
            )
            .setTimeout(0)
            .build();
          // Sign the transaction to prove you are actually the person sending it.
          transaction.sign(sourceKeys);
          // And finally, send it off to Diamante!
          return server.submitTransaction(transaction);
        })
        .then(function (result) {
          console.log("Success! Results:", result);
          return res.json(result);
        })
        .catch(function (error) {
          console.error("Something went wrong!", error);
        });
}

dataRouter.post('/add-data', async (req, res) => {
    try{
       await addData(res);
    }catch(e){
        console.log(e);
    }
});

module.exports = dataRouter;