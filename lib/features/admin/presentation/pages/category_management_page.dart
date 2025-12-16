import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/models/category_model.dart';
import '../../../category/presentation/providers/category_provider.dart';

class CategoryManagementPage extends ConsumerWidget {
  const CategoryManagementPage({super.key});
  
  void _showAddEditDialog(BuildContext context, WidgetRef ref, [CategoryModel? category]) {
    final nameController = TextEditingController(text: category?.name);
    final iconController = TextEditingController(text: category?.icon);
    final descriptionController = TextEditingController(text: category?.description);
    final formKey = GlobalKey<FormState>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(category == null ? AppStrings.addCategory : AppStrings.edit),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: nameController,
                label: 'نام دسته‌بندی',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'نام الزامی است';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: iconController,
                label: 'آیکون (ایموجی)',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: descriptionController,
                label: 'توضیحات',
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              
              final categoryModel = CategoryModel(
                id: category?.id ?? '',
                name: nameController.text.trim(),
                icon: iconController.text.trim().isNotEmpty 
                    ? iconController.text.trim() 
                    : null,
                description: descriptionController.text.trim().isNotEmpty 
                    ? descriptionController.text.trim() 
                    : null,
                createdAt: category?.createdAt ?? DateTime.now(),
              );
              
              bool success;
              if (category == null) {
                success = await ref
                    .read(categoryCrudControllerProvider.notifier)
                    .addCategory(categoryModel);
              } else {
                success = await ref
                    .read(categoryCrudControllerProvider.notifier)
                    .updateCategory(categoryModel);
              }
              
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
                
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        category == null
                            ? 'دسته‌بندی با موفقیت اضافه شد'
                            : 'دسته‌بندی با موفقیت به‌روزرسانی شد',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  ref.invalidate(categoriesProvider);
                } else {
                  final error = ref.read(categoryCrudControllerProvider).error;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error ?? 'خطا'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: Text(category == null ? AppStrings.save : AppStrings.edit),
          ),
        ],
      ),
    );
  }
  
  Future<void> _handleDelete(
    BuildContext context,
    WidgetRef ref,
    String categoryId,
    String categoryName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.delete),
        content: Text('آیا از حذف "$categoryName" اطمینان دارید؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
    
    if (confirmed == true && context.mounted) {
      final success = await ref
          .read(categoryCrudControllerProvider.notifier)
          .deleteCategory(categoryId);
      
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('دسته‌بندی با موفقیت حذف شد'),
              backgroundColor: Colors.green,
            ),
          );
          ref.invalidate(categoriesProvider);
        } else {
          final error = ref.read(categoryCrudControllerProvider).error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error ?? 'خطا در حذف دسته‌بندی'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.categoryManagement),
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return EmptyState(
              message: AppStrings.noCategoriesFound,
              icon: Icons.category_outlined,
              onRetry: () {
                ref.invalidate(categoriesProvider);
              },
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(categoriesProvider);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final category = categories[index];
                
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: category.icon != null
                        ? Text(
                            category.icon!,
                            style: const TextStyle(fontSize: 32),
                          )
                        : const Icon(Icons.category, size: 32),
                    title: Text(category.name),
                    subtitle: category.description != null
                        ? Text(category.description!)
                        : null,
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text(AppStrings.edit),
                            ],
                          ),
                          onTap: () {
                            Future.delayed(Duration.zero, () {
                              _showAddEditDialog(context, ref, category);
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: const Row(
                            children: [
                              Icon(Icons.delete, color: AppColors.error),
                              SizedBox(width: 8),
                              Text(
                                AppStrings.delete,
                                style: TextStyle(color: AppColors.error),
                              ),
                            ],
                          ),
                          onTap: () {
                            Future.delayed(Duration.zero, () {
                              _handleDelete(context, ref, category.id, category.name);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => CustomErrorWidget(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(categoriesProvider);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddEditDialog(context, ref);
        },
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.addCategory),
      ),
    );
  }
}

