import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/models/product_model.dart';
import '../../../product/presentation/providers/product_provider.dart';
import '../../../category/presentation/providers/category_provider.dart';

class AddEditProductPage extends ConsumerStatefulWidget {
  final String? productId;
  
  const AddEditProductPage({
    super.key,
    this.productId,
  });
  
  @override
  ConsumerState<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends ConsumerState<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController(text: '0');
  final _stockController = TextEditingController();
  
  String? _selectedCategoryId;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      // TODO: Load product data
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _stockController.dispose();
    super.dispose();
  }
  
  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لطفاً دسته‌بندی را انتخاب کنید'),
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    final product = ProductModel(
      id: widget.productId ?? '',
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text),
      discount: double.parse(_discountController.text),
      categoryId: _selectedCategoryId!,
      stock: int.parse(_stockController.text),
      images: [], // TODO: Add image upload
      createdAt: DateTime.now(),
    );
    
    bool success;
    if (widget.productId == null) {
      success = await ref
          .read(productCrudControllerProvider.notifier)
          .addProduct(product);
    } else {
      success = await ref
          .read(productCrudControllerProvider.notifier)
          .updateProduct(product);
    }
    
    setState(() => _isLoading = false);
    
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.productId == null
                  ? AppStrings.productAddedSuccessfully
                  : AppStrings.productUpdatedSuccessfully,
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      } else {
        final error = ref.read(productCrudControllerProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'خطا'),
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productId == null
              ? AppStrings.addProduct
              : AppStrings.editProduct,
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: _nameController,
                  label: 'نام محصول',
                  validator: (value) => Validators.required(value, 'نام محصول'),
                ),
                const SizedBox(height: 16),
                
                CustomTextField(
                  controller: _brandController,
                  label: AppStrings.brand,
                  validator: (value) => Validators.required(value, 'برند'),
                ),
                const SizedBox(height: 16),
                
                CustomTextField(
                  controller: _descriptionController,
                  label: AppStrings.description,
                  maxLines: 4,
                  validator: (value) => Validators.required(value, 'توضیحات'),
                ),
                const SizedBox(height: 16),
                
                // Category Dropdown
                categoriesAsync.when(
                  data: (categories) => DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: AppStrings.category,
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'دسته‌بندی الزامی است';
                      }
                      return null;
                    },
                  ),
                  loading: () => const LoadingIndicator(size: 30),
                  error: (error, stack) => Text('خطا: $error'),
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _priceController,
                        label: AppStrings.price,
                        keyboardType: TextInputType.number,
                        validator: (value) => Validators.positiveNumber(value, 'قیمت'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        controller: _discountController,
                        label: AppStrings.discount,
                        keyboardType: TextInputType.number,
                        validator: (value) => Validators.number(value, 'تخفیف'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                CustomTextField(
                  controller: _stockController,
                  label: AppStrings.stock,
                  keyboardType: TextInputType.number,
                  validator: (value) => Validators.number(value, 'موجودی'),
                ),
                const SizedBox(height: 32),
                
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(AppStrings.save),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

