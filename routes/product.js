const express = require('express');


const { getProducts, getProduct, createProduct, updateProduct, deleteProduct }
= require('../controllers/productController');

const router = express.Router();
router.get('/product', getProduct);
router.post('/product', createProduct);
router.put('/product/:id', updateProduct);
router.delete('/product/:id',  deleteProduct);

module.exports = router;