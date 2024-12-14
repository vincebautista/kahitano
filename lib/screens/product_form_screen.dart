import 'package:flutter/material.dart';
import '../models/product.dart';
import '../helpers/dbhelper.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  ProductFormScreen({this.product});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _skuController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _discountedPriceController;
  late TextEditingController _quantityController;
  late TextEditingController _manufacturerController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _skuController = TextEditingController(text: widget.product?.sku ?? '');
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _priceController =
        TextEditingController(text: widget.product?.price.toString() ?? '');
    _discountedPriceController = TextEditingController(
        text: widget.product?.discountedPrice.toString() ?? '');
    _quantityController =
        TextEditingController(text: widget.product?.quantity.toString() ?? '');
    _manufacturerController =
        TextEditingController(text: widget.product?.manufacturer ?? '');
    _imageUrlController =
        TextEditingController(text: widget.product?.imageUrl ?? '');
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id,
        sku: _skuController.text,
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        discountedPrice: double.parse(_discountedPriceController.text),
        quantity: int.parse(_quantityController.text),
        manufacturer: _manufacturerController.text,
        imageUrl: _imageUrlController.text,
      );

      final result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text(widget.product == null ? 'Add Product' : 'Update Product'),
            content: Text(
                'Are you sure you want to ${widget.product == null ? 'add' : 'update'} this product?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );

      if (result == true) {
        if (widget.product == null) {
          await DBHelper.instance.create(product);
        } else {
          await DBHelper.instance.update(product);
        }
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _skuController,
                decoration: InputDecoration(
                    labelText: 'SKU', border: OutlineInputBorder()),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter SKU' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Name', border: OutlineInputBorder()),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                    labelText: 'Description', border: OutlineInputBorder()),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter description' : null,
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                    labelText: 'Price', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter price' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _discountedPriceController,
                decoration: InputDecoration(
                    labelText: 'Discounted Price',
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter discounted price'
                    : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                    labelText: 'Quantity', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter quantity' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _manufacturerController,
                decoration: InputDecoration(
                    labelText: 'Manufacturer', border: OutlineInputBorder()),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter manufacturer' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                    labelText: 'Image URL', border: OutlineInputBorder()),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter image URL' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text(
                    widget.product == null ? 'Add Product' : 'Update Product'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _skuController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountedPriceController.dispose();
    _quantityController.dispose();
    _manufacturerController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
