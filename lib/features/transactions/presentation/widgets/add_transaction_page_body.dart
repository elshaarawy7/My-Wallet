import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/core/widgets/custem_text_from_filed.dart';
import 'package:my_wallet/core/widgets/custom_batton.dart';
import 'package:my_wallet/features/transactions/domain/entity/category_entity.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/catogogry/categories_cubit.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/catogogry/categories_state.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/transaction/transaction_cubit.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/transaction/transaction_state.dart';

class TransactionPageBody extends StatefulWidget {
  const TransactionPageBody({super.key});

  @override
  State<TransactionPageBody> createState() => _TransactionPageBodyState();
}

class _TransactionPageBodyState extends State<TransactionPageBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController amountController = TextEditingController();

  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();
  String? selectedCategoryId;

  @override
  void dispose() {
    amountController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTransactionCubit, AddTransactionState>(
      listener: (context, state) {
        if (state is AddTransactionFailure) {
          Fluttertoast.showToast(
            msg: state.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        if (state is AddTransactionSuccess) {
          Fluttertoast.showToast(
            msg: "تم إضافة المعاملة بنجاح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          amountController.clear();
          titleController.clear();
          descriptionController.clear();
          GoRouter.of(context).pop(true);
        }
      },
      builder: (context, state) {
        final cubit = AddTransactionCubit.get(context);
        return SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Gap(75),

                    BlocBuilder<CategoriesCubit, CategoriesState>(
                      builder: (context, categoriesState) {
                        if (categoriesState is CategoriesLoading ||
                            categoriesState is CategoriesInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (categoriesState is CategoriesFailure) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                categoriesState.message,
                                textAlign: TextAlign.right,
                                style: const TextStyle(color: Colors.red),
                              ),
                              TextButton(
                                onPressed: () => context
                                    .read<CategoriesCubit>()
                                    .loadCategories(),
                                child: const Text('إعادة تحميل التصنيفات'),
                              ),
                            ],
                          );
                        }

                        final categories =
                            (categoriesState as CategoriesLoaded).categories;
                        final visibleCategories = _visibleCategories(
                          categories,
                        );
                        if (visibleCategories.isEmpty) {
                          return const Text(
                            'لا توجد تصنيفات في حسابك. أضف تصنيفًا من الـAPI أولًا.',
                            textAlign: TextAlign.right,
                          );
                        }

                        final effectiveSelectedId =
                            visibleCategories.any(
                              (category) => category.id == selectedCategoryId,
                            )
                            ? selectedCategoryId
                            : visibleCategories.first.id;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'تلقائي ومقترح',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'التصنيف السريع',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(12),
                            SizedBox(
                              height: 75,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: visibleCategories.map((category) {
                                    return Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        end: 8,
                                      ),
                                      child: SizedBox(
                                        width: 75,
                                        child: _CategoryTile(
                                          name: _categoryDisplayName(
                                            category.name,
                                          ),
                                          icon: _categoryIcon(category.name),
                                          isSelected:
                                              category.id ==
                                              effectiveSelectedId,
                                          onTap: () => setState(
                                            () => selectedCategoryId =
                                                category.id,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    Gap(20),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "أضافة معاملة جديدة",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),

                    Gap(20),

                    CustomTextField(
                      controller: amountController,
                      label: "المبلغ",
                      hintText: "1000",
                      prefixIcon: Icons.attach_money,
                      isPassword: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "من فضلك ادخل المبلغ";
                        }
                        return null;
                      },
                    ),

                    Gap(20),

                    CustomTextField(
                      label: "اشتريت ايه ؟",
                      hintText: ".....",
                      isPassword: false,
                      prefixIcon: Icons.textsms,
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "من فضلك ادخل عنوان المعاملة";
                        }
                        return null;
                      },
                    ),

                    const Gap(24),

                    state is AddTransactionLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : CustomBatton(
                            text: "أضافة معاملة",
                            onPressed: () async {
                              final categoriesState = context
                                  .read<CategoriesCubit>()
                                  .state;
                              if (selectedCategoryId == null &&
                                  categoriesState is CategoriesLoaded &&
                                  _visibleCategories(categoriesState.categories)
                                      .isNotEmpty) {
                                selectedCategoryId = _visibleCategories(
                                  categoriesState.categories,
                                ).first.id;
                              }
                              if (formKey.currentState!.validate()) {
                                if (selectedCategoryId == null) {
                                  Fluttertoast.showToast(
                                    msg: 'من فضلك اختر تصنيفًا للمعاملة',
                                  );
                                  return;
                                }
                                await cubit.addTransaction(
                                  type: "expense",
                                  categoryId: selectedCategoryId!,
                                  currencyCode: "EGP",
                                  amount: double.parse(amountController.text),
                                  exchangeRate: 1,
                                  baseCurrencyAmount: double.parse(
                                    amountController.text,
                                  ),
                                  description: titleController.text,
                                  transactionDate: DateTime.now(),
                                );
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

IconData _categoryIcon(String name) {
  final normalizedName = name.toLowerCase();
  if (normalizedName.contains('أكل') ||
      normalizedName.contains('طعام') ||
      normalizedName.contains('مطعم') ||
      normalizedName.contains('food') ||
      normalizedName.contains('restaurant')) {
    return Icons.restaurant;
  }
  if (normalizedName.contains('مواصلات') ||
      normalizedName.contains('نقل') ||
      normalizedName.contains('سيارة') ||
      normalizedName.contains('transport') ||
      normalizedName.contains('car')) {
    return Icons.directions_car_filled_outlined;
  }
  if (normalizedName.contains('مشتريات') ||
      normalizedName.contains('تسوق') ||
      normalizedName.contains('shopping')) {
    return Icons.shopping_bag_outlined;
  }
  if (normalizedName.contains('فاتورة') ||
      normalizedName.contains('فواتير') ||
      normalizedName.contains('bill')) {
    return Icons.receipt_long_outlined;
  }
  if (normalizedName.contains('تعليم') ||
      normalizedName.contains('دراسة') ||
      normalizedName.contains('school') ||
      normalizedName.contains('education')) {
    return Icons.school_outlined;
  }
  if (normalizedName.contains('صحة') ||
      normalizedName.contains('طبي') ||
      normalizedName.contains('health')) {
    return Icons.medical_services_outlined;
  }
  if (normalizedName.contains('ترفيه') ||
      normalizedName.contains('entertainment')) {
    return Icons.movie_outlined;
  }
  if (normalizedName.contains('أخرى') ||
      normalizedName.contains('اخرى') ||
      normalizedName.contains('other')) {
    return Icons.more_horiz;
  }
  return Icons.more_horiz;
}

List<CategoryEntity> _visibleCategories(List<CategoryEntity> categories) {
  final visibleCategories = categories.where((category) {
    final normalizedName = category.name
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .toLowerCase()
        .trim();
    return normalizedName != 'راتب' &&
        normalizedName != 'دخل إضافي' &&
        normalizedName != 'دخل اضافي' &&
        normalizedName != 'salary' &&
        normalizedName != 'additional income' &&
        normalizedName != 'extra income';
  }).toList();

  visibleCategories.sort((first, second) {
    final firstIsOther = _isOtherCategory(first.name);
    final secondIsOther = _isOtherCategory(second.name);
    if (firstIsOther == secondIsOther) {
      return 0;
    }
    return firstIsOther ? 1 : -1;
  });
  return visibleCategories;
}

bool _isOtherCategory(String name) {
  final normalizedName = name
      .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
      .toLowerCase()
      .trim();
  return normalizedName == 'أخرى' ||
      normalizedName == 'اخرى' ||
      normalizedName == 'other';
}

String _categoryDisplayName(String name) {
  return _isOtherCategory(name) ? 'أخرى' : name;
}

class _CategoryTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor = isSelected ? Colors.white : AppColors.textPrimary;

    return Material(
      color: isSelected ? AppColors.primaryColor : const Color(0xFFF0F1F4),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 75,
          height: 75,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.16)
                        : const Color(0xFFE1E2E6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 19,
                    color: isSelected ? Colors.white : const Color(0xFF4B5060),
                  ),
                ),
                const Gap(3),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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
