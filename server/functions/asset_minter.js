const express = require('express');
var DiamSdk = require("diamante-sdk-js");
var fetch = require("node-fetch");
const minterRouter = express.Router();
const { Asset } = require('diamante-sdk-js');
const {TransactionBuilder} = require('diamante-sdk-js');
const {Keypair} = require('diamante-sdk-js');
const {BASE_FEE} = require('diamante-sdk-js');
const {Operation} = require('diamante-sdk-js');

// dis public = "GD57QPEMR5ITCIAGA3PGIU4TU7CQPCHXQ7UAWTHGLDJDL5KPH3KEQA7J";
// dis secret = "SDZZMINYGBXBP2YWNRFBYSFOJYSCB2EB2FHK27X3GCLMMWITYL3D6I6W";
// res public = "GBMW4OURLY5J6PFU7VBLBC2LSSX3CE377MN2QVSR76CWIZMLAHGVNCQJ";

async function assetMinter(asset_name, distributor, recevier) {
    try {
        var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");

        const account = await server.loadAccount("GD57QPEMR5ITCIAGA3PGIU4TU7CQPCHXQ7UAWTHGLDJDL5KPH3KEQA7J");
        const asset = new Asset(
            "HH",
            "GD57QPEMR5ITCIAGA3PGIU4TU7CQPCHXQ7UAWTHGLDJDL5KPH3KEQA7J"
        );

        const transaction = new TransactionBuilder(account, {
            fee: BASE_FEE,
            networkPassphrase: "Diamante Testnet",
        })
            .addOperation(
                Operation.payment({
                    destination: "GBMW4OURLY5J6PFU7VBLBC2LSSX3CE377MN2QVSR76CWIZMLAHGVNCQJ",
                    asset,
                    amount: "17",
                })
            )
            .setTimeout(100)
            .build();

        transaction.sign(Keypair.fromSecret("SDZZMINYGBXBP2YWNRFBYSFOJYSCB2EB2FHK27X3GCLMMWITYL3D6I6W"));
        const result = await server.submitTransaction(transaction);
        if (result.successful === true) {
            console.log("###################################")

            console.log()
            console.log("Asset ", asset.code, " distributed  to ", "GBMW4OURLY5J6PFU7VBLBC2LSSX3CE377MN2QVSR76CWIZMLAHGVNCQJ")
            console.log("Transaction hash: ", result.hash)

            console.log()

            console.log("###################################")

        }
    } catch (e) {
        console.log(e);

    }
}

minterRouter.post('/asset-minter', async (req, res) =>{
    try{
        await assetMinter("HH", "GD57QPEMR5ITCIAGA3PGIU4TU7CQPCHXQ7UAWTHGLDJDL5KPH3KEQA7J", "");
    }catch(e){
        console.log(`${e}`);
    }
});

module.exports = minterRouter;