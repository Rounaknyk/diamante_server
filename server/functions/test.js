const express = require('express');
const testRouter = express.Router();


testRouter.post('/test', (req, res) => {
    console.log("Hello Lode Nishchal!");
});

module.exports = testRouter;