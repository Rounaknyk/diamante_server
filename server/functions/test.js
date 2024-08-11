const express = require('express');
const testRouter = express.Router();


testRouter.get('/test', (req, res) => {
    console.log("Hello Lode Nishchal!");
});

module.exports = testRouter;