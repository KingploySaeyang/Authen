const express = require('express');
const router = express.Router();

const { getProduct, createProduct, updateProduct, deleteProduct }
= require('../controllers/productController');

router.get('/product', getProduct);
router.post('/product', createProduct);
router.put('/product/:id', updateProduct);
router.delete('/product/:id',  deleteProduct);

module.exports = router;