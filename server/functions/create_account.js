const express = require('express');
var DiamSdk = require("diamante-sdk-js");
var fetch = require("node-fetch");
const accRouter = express.Router();
const { Asset } = require('diamante-sdk-js');
const {TransactionBuilder} = require('diamante-sdk-js');
const {Keypair} = require('diamante-sdk-js');
const {BASE_FEE} = require('diamante-sdk-js');
const {Aurora} = require('diamante-sdk-js');
const {Server} = require('diamante-sdk-js');
const {Operation} = require('diamante-sdk-js');
const { Resolver } = require('diamante-sdk-js/lib/stellartoml');

// setupRecevier("GAS56X7NFIVQUAXA3JMLPIPPNWV4FOTJ7ODTRU3VDC5TM4Y7NSAEEB57", "GDUJ7O2MRH72ZRGV26RVKM7547O25JAYHOFRZZDYISYM4LNFAEGGUZA7", "BridgeGoa").then(function () {
//   assetMinter("BridgeGoa", "GDUJ7O2MRH72ZRGV26RVKM7547O25JAYHOFRZZDYISYM4LNFAEGGUZA7", "GAS56X7NFIVQUAXA3JMLPIPPNWV4FOTJ7ODTRU3VDC5TM4Y7NSAEEB57");
// })

// mintAndTransferAsset("", "", s"", "");

async function mintAndTransferAsset(pair, publicKey, assetCode, supply) {
  const server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");

  try {
    // Load the account
    const pairAccount = await server.loadAccount("GAS56X7NFIVQUAXA3JMLPIPPNWV4FOTJ7ODTRU3VDC5TM4Y7NSAEEB57");

    // Create asset
    const _asset = new DiamSdk.Asset("Bridggg", "GAS56X7NFIVQUAXA3JMLPIPPNWV4FOTJ7ODTRU3VDC5TM4Y7NSAEEB57");

    // Build the minting transaction
    let transaction = new DiamSdk.TransactionBuilder(pairAccount, {
      fee: DiamSdk.BASE_FEE,
      networkPassphrase: DiamSdk.Networks.TESTNET,
    })
      .addOperation(
        DiamSdk.Operation.payment({
          destination: "GDPAAM26D55ORFAZQPZBCQF3KHE25K5AU6CUMAADI4CXSC2PJXU2AUEI",
          asset: _asset,
          amount: "8",
        })
      )
      .setTimeout(100)
      .build();

    // Sign the transaction
    const issuingKeys = DiamSdk.Keypair.fromSecret("SBEQSONKMFK6ZNPL64TMRC3666REZUZLO7SSD3AYOK2FRK5LTF4JJTX7");
    transaction.sign(issuingKeys);

    // Submit the minting transaction
    const mintResult = await server.submitTransaction(transaction);
    console.log('Minting transaction successful:', mintResult);

    // Build the transfer transaction
    let transferTx = new DiamSdk.TransactionBuilder(pairAccount, {
      fee: DiamSdk.BASE_FEE,
      networkPassphrase: DiamSdk.Networks.TESTNET,
    })
      .addOperation(
        DiamSdk.Operation.payment({
          destination: "GDPAAM26D55ORFAZQPZBCQF3KHE25K5AU6CUMAADI4CXSC2PJXU2AUEI",
          asset: _asset,
          amount: "1000",
        })
      )
      .setTimeout(0)
      .build();

    // Sign the transfer transaction
    transferTx.sign(issuingKeys);

    // Submit the transfer transaction
    const transferResult = await server.submitTransaction(transferTx);
    console.log('Transfer transaction successful:', transferResult);

    if (transferResult.successful) {
      console.log('Asset minted and transferred successfully. Check your wallet, happy tokenisation!');
      return true;
    } else {
      console.log('Transactions failed');
      return false;
    }
  } catch (error) {
    console.error('Error:', error);
    return false;
  }
}

// Usage example:
// const pair = DiamanteSdk.Keypair.fromSecret('YOUR_SECRET_KEY');
// const publicKey = 'DESTINATION_PUBLIC_KEY';
// const assetCode = 'ASSET_CODE';
// const supply = '1000'; // as a string

// mintAndTransferAsset(pair, publicKey, assetCode, supply)
//   .then(result => console.log('Operation result:', result))
//   .catch(error => console.error('Operation failed:', error));


accRouter.post('/mint', async (req, res) =>{
  const {assetName, amount, parentPublicKey, childPublicKey} = req.body;
  await assetMinter(res, assetName, amount, childPublicKey, parentPublicKey);
});

// assetMinter(res, "", "", "");
async function assetMinter(res, astName, amo, rec, dis) {
  // console.log("Asda");
  assetName = Buffer.from(astName, 'utf8').toString();
  _amount = Buffer.from(amo, 'utf8').toString();
  distributor = Buffer.from(dis, 'utf8').toString();
  recevier = Buffer.from(rec, 'utf8').toString();
  
  console.log("Minting...");
  console.log(`ASSET NAME: ${assetName}`);
  console.log(`Amount: ${_amount}`);
  console.log(`dis: ${distributor}`);
  console.log(`rec: ${recevier}`);

  try {
      const server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");

      const account = await server.loadAccount(distributor); //distributor); //"GA3SXDTF26ERV3ZVPH3NG7AGWX772JZCNEOFFZR2EFEH57LI3XZO7OUF");
      const _asset = new Asset(
          assetName,
          distributor //distributor //"GA3SXDTF26ERV3ZVPH3NG7AGWX772JZCNEOFFZR2EFEH57LI3XZO7OUF"//CHILD ACCOUNT
      );

      const transaction = new TransactionBuilder(account, {
          fee: BASE_FEE,
          networkPassphrase: "Diamante Testnet",
      })
          .addOperation(
              Operation.payment({
                  destination: recevier,//recevier, //"GCNLWIT4BKHN4Y4KSNLEOCTRC7YKWSHULAYGQN3FN4GCZSYSKE4G7FTC", //parent account
                  asset: _asset,
                  amount: _amount,
              })
          )
          // .addOperation(
          //   Operation.manageData({
          //       name: assetName,
          //       value: `governing asset`,
          //   })
          // )
          //   .addOperation(
          //     Operation.setOptions({
          //       masterWeight: 0,
          //     })
            // )
            .setTimeout(100)
          .build();
          console.log(`TRANS ID: ${transaction.toEnvelope().toXDR('base64')}`);
          return res.json({'text' : transaction.toEnvelope().toXDR('base64')});

          // console.log(`TRANSSSS: ${transaction}`);
      // transaction.sign(Keypair.fromSecret("SDCKVXEVLCBPNO3SXR6PWLIFKFHFTSYIR2PZ4PW2JDE53VDYEVU2ZRJR"));
      // const result = await server.submitTransaction(transaction);

      // if (result.successful === true) {
      //     console.log("###################################")

      //     console.log()
      //     console.log("Asset ", asset.code, " distributed  to ", "GDPAAM26D55ORFAZQPZBCQF3KHE25K5AU6CUMAADI4CXSC2PJXU2AUEI")
      //     console.log("Transaction hash: ", result.hash)

      //     console.log()

      //     console.log("###################################")


      // }
  } catch (e) {
      console.log(e);

  }


}

accRouter.post('/generate-keys', (req, res) => {
  try{
    console.log("asd");
    const pair = DiamSdk.Keypair.random();

    console.log("PAIR: "+pair.publicKey());
    console.log("PAIR: "+pair.secret());
    const publicKey = pair.publicKey();
    const secretKey = pair.secret();

    return res.json({"publicKey" : publicKey, "secretKey" : secretKey});
  }catch(e){
    console.log(e);
    return res(e);
  }
});

// setupRecevier("", "", "");
async function setupRecevier(recevier, distributor, asset_name) {
  try {
    const server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");

      var issuingKeys = DiamSdk.Keypair.fromSecret(
        "SC4I55A7DI3UGH4S72PGDCH5JL4C3G3OKRGOHDYQSI6OOP35PLCUYLPP"
      );
      
      var receivingKeys = DiamSdk.Keypair.fromSecret(
        "SDILEZ54H53ILMRKZ72JRWRGTYOR7YPN457ASA3KHPCI4IWD74DUVFBS"
      );


      const account = await server.loadAccount(receivingKeys.publicKey());

      const _asset = new Asset(
          "RBj",
          issuingKeys.publicKey(), //issuer
      );

      const transaction = new TransactionBuilder(account, {
          fee: BASE_FEE,
          networkPassphrase: "Diamante Testnet",
      })
          .addOperation(
              Operation.changeTrust({ asset: _asset, limit: "1000" })
          )
          .setTimeout(100)
          .build();

      transaction.sign(receivingKeys);
      const result = await server.submitTransaction(transaction);
      if (result.successful === true) {
          console.log("###################################")

          console.log()
          console.log("Trustline created for ", _asset.code, " with issuer ", _asset.getIssuer())
          console.log("Transaction hash: ", result.hash)

          console.log()

          console.log("###################################")
      }
  } catch (e) {
      console.log(e);

  }
}

async function getTrx(res, key){
  console.log("HEOA");

  const parentKey = Buffer.from(key, 'utf8').toString();
  console.log(`TRX KEY 2 ${parentKey}`);

  try{
    const pair = DiamSdk.Keypair.random();
    console.log(pair);

    console.log("Child Public key: "+pair.publicKey());
    console.log("Child Private key: "+pair.secret());
    console.log("PARENT PUBLIC: "+parentKey);
    var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");

    var parentAccount = await server.loadAccount(parentKey); //make sure the parent account exists on ledger
    console.log(`parent ${parentKey}`);
    var createAccountTx = new DiamSdk.TransactionBuilder(parentAccount, {
      fee: DiamSdk.BASE_FEE,
      networkPassphrase: DiamSdk.Networks.TESTNET,
    });
    console.log("reach");
    // console.log("CHILD KEY "+pairPublicKey);
    
    createAccountTx = await createAccountTx
    .addOperation(
      DiamSdk.Operation.createAccount({
        destination: pair.publicKey(),
        startingBalance: "1000",
      })
    )
    .setTimeout(180)
    .build();

    // createAccountTx = await createAccountTx
    //     .addOperation(
    //       DiamSdk.Operation.createAccount({
    //         destination: childAccount.publicKey(),
    //         asset: _asset,
    //         startingBalance: "7",
    //       })
    //     )
    //     .setTimeout(180)
    //     .build();

    console.log("reace2");

    var text = createAccountTx.toEnvelope().toXDR('base64');
    console.log(text);

    // await createAccountTx.sign(Keypair.fromSecret("SCEPPY2DZNZZEM6UTMPBH3FJO5UQ6TELPPLTSOC3STY4VRH7ID3YJDYY"));
    //submit the transaction
    // console.log("reace3");

    // let txResponse = await server.submitTransaction(createAccountTx)

    // console.log(txResponse);
      
    return res.json({'text': text, 'childPublicKey': pair.publicKey(), 'childSecretKey': pair.secret()});

  }catch(e){
    res.json(e);
    console.log(e);
  }
}

async function createTrust(res, assetName, parentPublicKey, childPublicKey){

  var parentAcc = Buffer.from(parentPublicKey, 'utf8').toString();
  var childAcc = Buffer.from(childPublicKey, 'utf8').toString();
  var assetName = Buffer.from(assetName, 'utf8').toString();

  console.log(`ASSET NAME: ${assetName}`);

  console.log("Parent Account Public:", parentAcc);
  console.log("Child Account Public:", childAcc);
  console.log("Asset:", assetName);


  try {
    const server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");

      const account = await server.loadAccount(parentAcc);//"GCNLWIT4BKHN4Y4KSNLEOCTRC7YKWSHULAYGQN3FN4GCZSYSKE4G7FTC");//parentAcc);//"GCNLWIT4BKHN4Y4KSNLEOCTRC7YKWSHULAYGQN3FN4GCZSYSKE4G7FTC");

      const _asset = new Asset(
          assetName,
          childAcc//"GD74RVUGGCWYPAISASXZ7B7TGUHLB4BHISTRDEKXC74GHOOWEKGPQRZM"//recKey.publicKey()//"GBLKYDDPI4OMEHDSSCINAQFKA4VWVYB3PVMFCNNSFB6MJKZLERE66BTC", //issuer
      );

      const transaction = new TransactionBuilder(account, {
          fee: BASE_FEE,
          networkPassphrase: "Diamante Testnet",
      })
          .addOperation(
              Operation.changeTrust({ asset: _asset})
          )
          .setTimeout(100)
          .build();

          console.log("TRUST 2");
          console.log(transaction.toEnvelope().toXDR('base64'));
          return res.json({"text": transaction.toEnvelope().toXDR('base64')});

      // transaction.sign(recKey);
      // const result = await server.submitTransaction(transaction);

      // return res.json({"text": "trustline created", status: 200});


      // if (result.successful === true) {
      //     console.log("###################################")

      //     console.log()
      //     console.log("Trustline created for ", _asset.code, " with issuer ", _asset.getIssuer())
      //     console.log("Transaction hash: ", result.hash)

      //     console.log()

      //     console.log("###################################")
      // }
  } catch (e) {
      console.log(e);
  }
}

accRouter.post('/create-trust', async (req, res) => {
  try{
    console.log("hi");
    const {assetName, parentPublicKey, childPublicKey} = req.body;
    await createTrust(res,assetName, parentPublicKey, childPublicKey);
  }catch(e){
    console.log(e);
  }
});

accRouter.post('/trx', async (req, res) => {
  console.log("eajs2")
  const {key} = req.body;
  console.log(`TRX KEY ${key}`);
  await getTrx(res, "GDNHJZG7HFLOD3DJCYYIK3JGV4GJQOHQXBDME5L77TRHJUJ6S4DZSHLU");
});

// createAccount("SBEQSONKMFK6ZNPL64TMRC3666REZUZLO7SSD3AYOK2FRK5LTF4JJTX7");
// assetMinter("bRIDHH", "GAS56X7NFIVQUAXA3JMLPIPPNWV4FOTJ7ODTRU3VDC5TM4Y7NSAEEB57", "GDPAAM26D55ORFAZQPZBCQF3KHE25K5AU6CUMAADI4CXSC2PJXU2AUEI");

async function createParentAcc(res, publicKey){
  try {
      const response = await fetch(
            `https://friendbot.diamcircle.io?addr=${encodeURIComponent(publicKey)}`
          );
        const responseJSON = await response.json();
              console.log("SUCCESS! You have a new account :)\n", responseJSON);
              parentJson = responseJSON;
              return res.json(responseJSON);
      } catch (e) {
      console.error("ERROR!", e);
      parentJson = null;
      
      return null;
    }
}

accRouter.post('/create-parent-account', async (req, res) => {
  try{
    const {key} = req.body;
    console.log(key);
    await createParentAcc(res, key);
  }catch(e){
    console.log(e);
  }
});

async function createAccount(res){

    // console.log(Keypair.fromSecret(parentKey));

    const pair = DiamSdk.Keypair.random();

    console.log("PAIR: "+pair.publicKey());
    console.log("PAIR: "+pair.secret());
    const pairPublicKey = pair.publicKey();
    const pairSecretKey = pair.secret();
    var parentJson;
    var childJson;
    try {
      const response = await fetch(
            `https://friendbot.diamcircle.io?addr=${encodeURIComponent(pairPublicKey)}`
          );
        const responseJSON = await response.json();
              console.log("SUCCESS! You have a new account :)\n", responseJSON);
              parentJson = responseJSON;
      } catch (e) {
      console.error("ERROR!", e);
      parentJson = null;
      return null;
    }
    // After you've got your test lumens from friendbot, we can also use that account to create a new account on the ledger.
    try {
      const server = new DiamSdk.Horizon.Server(
        "https://diamtestnet.diamcircle.io/"
      );
      var parentAccount = await server.loadAccount("GCE74R62DR5F4AKF6LNYTTGHPMIDJWBPYB7HXDVGLSMTFI6SOBLSWHYJ"); //make sure the parent account exists on ledger
      var childAccount = DiamSdk.Keypair.random(); //generate a random account to create
      //create a transacion object.
      var createAccountTx = new DiamSdk.TransactionBuilder(parentAccount, {
        fee: DiamSdk.BASE_FEE,
        networkPassphrase: DiamSdk.Networks.TESTNET,
      });
      //add the create account operation to the createAccountTx transaction.

      const _asset = new Asset(
        "BridgeGoa",
        pairPublicKey
    );
      createAccountTx = await createAccountTx
        .addOperation(
          DiamSdk.Operation.createAccount({
            destination: childAccount.publicKey(),
            asset: _asset,
            startingBalance: "7",
          })
        )
        .setTimeout(180)
        .build();
      //sign the transaction with the account that was created from friendbot.
      // var acc = await Keypair.fromPublicKey(parentKey);
      await createAccountTx.sign(Keypair.fromSecret(pairSecretKey));
      //submit the transaction
      let txResponse = await server
        .submitTransaction(createAccountTx)
        // some simple error handling
        .catch(function (error) {
          console.log("there was an error");
          console.log(error.response);
          console.log(error.status);
          console.log(error.extras);
          return null;
        });
      childJson = txResponse;
      //console.log(txResponse);
        var data = {"parentJson": parentJson, "childJson": childJson, "childPublicKey": childAccount.publicKey(), "pairPublicKey": pairPublicKey, "pairSecretKey": pairSecretKey};
      //console.log(data);
      console.log(data);
      // assetMinter("Vurd d", "GAS56X7NFIVQUAXA3JMLPIPPNWV4FOTJ7ODTRU3VDC5TM4Y7NSAEEB57", childAccount.publicKey()); 
      // return res.json({parentJson: parentJson, childJson: childJson, childPublicKey: childAccount.publicKey(), pairPublicKey: pairPublicKey, pairSecretKey: pairSecretKey});
    } catch (e) {
      console.error("ERROR!", e);
      childJson = null;
  }
};

accRouter.post('/create-account', async (req, res) => {
    try{
      const {key} = req.body;
    //await assetMinter('HH', 'GD57QPEMR5ITCIAGA3PGIU4TU7CQPCHXQ7UAWTHGLDJDL5KPH3KEQA7J', 'GBMW4OURLY5J6PFU7VBLBC2LSSX3CE377MN2QVSR76CWIZMLAHGVNCQJ');
      await createAccount(res, key);
    }catch(e){
        console.log(e);
        return res.status(500).json({"error" : `Server error ${e}`});
    }
});

module.exports = accRouter;