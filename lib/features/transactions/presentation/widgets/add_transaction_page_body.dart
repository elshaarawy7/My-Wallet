import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/core/widgets/custem_text_from_filed.dart';
import 'package:my_wallet/core/widgets/custom_batton.dart';
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

                    const Gap(20),

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
                        if (categories.isEmpty) {
                          return const Text(
                            'لا توجد تصنيفات في حسابك. أضف تصنيفًا من الـAPI أولًا.',
                            textAlign: TextAlign.right,
                          );
                        }

                        return DropdownButtonFormField<String>(
                          initialValue:
                              selectedCategoryId ?? categories.first.id,
                          decoration: const InputDecoration(
                            labelText: 'التصنيف',
                            border: OutlineInputBorder(),
                          ),
                          items: categories
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category.id,
                                  child: Text(category.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() => selectedCategoryId = value);
                          },
                        );
                      },
                    ),

                    Gap(30),

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
                                  categoriesState.categories.isNotEmpty) {
                                selectedCategoryId =
                                    categoriesState.categories.first.id;
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
