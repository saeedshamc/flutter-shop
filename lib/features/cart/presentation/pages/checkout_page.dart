import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatter.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../providers/cart_provider.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});
  
  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  
  String _selectedPaymentMethod = 'cash';
  
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }
  
  void _handleCheckout() {
    if (!_formKey.currentState!.validate()) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تایید سفارش'),
        content: const Text('آیا از ثبت سفارش اطمینان دارید؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Process order
              ref.read(cartProvider.notifier).clearCart();
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سفارش شما با موفقیت ثبت شد!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('تایید'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartState = ref.watch(cartProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسویه حساب'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'خلاصه سفارش',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      ...cartState.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.product.name} x ${item.quantity}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                              Text(
                                Formatter.price(item.totalPrice),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'مجموع:',
                            style: theme.textTheme.headlineSmall,
                          ),
                          Text(
                            Formatter.price(cartState.totalPrice),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Shipping Address
              Text(
                'آدرس تحویل',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _nameController,
                label: 'نام و نام خانوادگی',
                prefixIcon: const Icon(Icons.person),
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _phoneController,
                label: 'شماره تماس',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone),
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _addressController,
                label: 'آدرس کامل',
                maxLines: 3,
                prefixIcon: const Icon(Icons.location_on),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _cityController,
                      label: 'شهر',
                      prefixIcon: const Icon(Icons.location_city),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _postalCodeController,
                      label: 'کد پستی',
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.markunread_mailbox),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Payment Method
              Text(
                'روش پرداخت',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              
              RadioListTile<String>(
                title: const Text('پرداخت نقدی'),
                subtitle: const Text('پرداخت در محل'),
                value: 'cash',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() => _selectedPaymentMethod = value!);
                },
              ),
              RadioListTile<String>(
                title: const Text('کارت به کارت'),
                subtitle: const Text('انتقال بانکی'),
                value: 'bank',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() => _selectedPaymentMethod = value!);
                },
              ),
              
              const SizedBox(height: 32),
              
              // Checkout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleCheckout,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('ثبت سفارش'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

