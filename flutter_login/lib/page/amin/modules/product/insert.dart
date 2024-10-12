import 'package:flutter/material.dart';
import 'package:flutter_login/controllers/product_controller.dart';
import 'package:flutter_login/models/product_model.dart';
import 'package:flutter_login/page/amin/view/admin_page.dart';
import 'package:flutter_login/provider/user_provider.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productTypeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  late ProductController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProductController();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productTypeController.dispose();
    _priceController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _submitProduct(String token) async {
    if (_formKey.currentState!.validate()) {
      try {
        // ตรวจสอบว่าราคาไม่ว่าง
        if (_priceController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a price')),
          );
          return; // ไม่ทำต่อหากราคาไม่ถูกต้อง
        }

        // แปลงราคาเป็นตัวเลข
        final price = int.parse(_priceController.text);

        // สร้าง ProductModel ใหม่
        final newProduct = ProductModel(
          productName: _productNameController.text,
          productType: _productTypeController.text,
          price: price,
          unit: _unitController.text,
        );

        // ส่งข้อมูลผลิตภัณฑ์ใหม่ไปยังเซิร์ฟเวอร์
        await _controller.postProduct(token, newProduct);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully!')),
        );

        // นำทางกลับไปยัง AdminPage
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AdminPage()),
          (route) => false, // ลบเส้นทางก่อนหน้า
        );
      } catch (e) {
        // จัดการข้อผิดพลาดเมื่อแปลงราคาไม่สำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<UserProvider>(context).accessToken;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _productTypeController,
                decoration: const InputDecoration(labelText: 'Product Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: 'Unit'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitProduct(token),
                child: const Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
