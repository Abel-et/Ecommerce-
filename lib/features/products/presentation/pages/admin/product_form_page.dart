import 'package:ecommerce/features/products/domain/entities/product_entity.dart';
import 'package:ecommerce/features/products/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:ecommerce/features/products/presentation/bloc/product_bloc/product_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductFormPage extends StatefulWidget {
  final ProductEntity? product;

  const ProductFormPage({super.key, this.product});

  bool get isEditing => product != null;

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _imageController;
  late final TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.productName);
    _descriptionController =
        TextEditingController(text: product?.productDescription);
    _priceController =
        TextEditingController(text: product?.productPrice.toString());
    _imageController = TextEditingController(text: product?.imageUrl);
    _categoryController =
        TextEditingController(text: product?.productCategory);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final existing = widget.product;
    final product = ProductEntity(
      productId: existing?.productId ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      productName: _nameController.text.trim(),
      productDescription: _descriptionController.text.trim(),
      productPrice: double.parse(_priceController.text.trim()),
      imageUrl: _imageController.text.trim(),
      productCategory: _categoryController.text.trim(),
      createdAt: existing?.createdAt ?? DateTime.now(),
    );

    final bloc = context.read<ProductBloc>();
    bloc.add(
      widget.isEditing
          ? UpdateProductEvent(product: product)
          : CreateProductEvent(product: product),
    );
    Navigator.of(context).pop(product);
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  String? _price(String? value) {
    if (_required(value) != null) return _required(value);
    return double.tryParse(value!.trim()) == null ? 'Enter a valid price' : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _field(_nameController, 'Product name', Icons.shopping_bag_outlined),
            _field(
              _descriptionController,
              'Description',
              Icons.description_outlined,
              maxLines: 3,
            ),
            _field(
              _priceController,
              'Price',
              Icons.payments_outlined,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: _price,
            ),
            _field(_categoryController, 'Category', Icons.category_outlined),
            _field(
              _imageController,
              'Image URL',
              Icons.image_outlined,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _submit,
              icon: Icon(widget.isEditing ? Icons.save : Icons.add),
              label: Text(widget.isEditing ? 'Update Product' : 'Save Product'),
            ),
            if (widget.isEditing) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  context
                      .read<ProductBloc>()
                      .add(DeleteProductEvent(widget.product!.productId));
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete Product'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator ?? _required,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
