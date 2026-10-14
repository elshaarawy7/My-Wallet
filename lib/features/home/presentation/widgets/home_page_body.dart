import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:my_wallet/core/widgets/custem_text_from_filed.dart';
import 'package:my_wallet/core/widgets/custom_batton.dart';
import 'package:my_wallet/features/home/presentation/widgets/balance_cart.dart';
import 'package:my_wallet/features/home/presentation/widgets/monthly_calendar_card.dart';
import 'package:my_wallet/features/transactions/domain/entity/category_entity.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/catogogry/categories_cubit.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/catogogry/categories_state.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/get_transaction/get_transaction_cubit.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/transaction/transaction_cubit.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/transaction/transaction_state.dart';

class HomePageBody extends StatefulWidget {
  final String? userName;

  const HomePageBody({super.key, this.userName});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  final TextEditingController incomeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    incomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Text(
                  'مرحبا بك يا ${widget.userName?.trim().isNotEmpty == true ? widget.userName!.trim() : 'مستخدم'} 👋',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ), 

              SliverGap(10),

              SliverToBoxAdapter(
                child: BlocConsumer<AddTransactionCubit, AddTransactionState>(
                  listener: (context, state) {
                    if (state is AddTransactionSuccess) {
                      incomeController.clear();
                      context.read<TransactionCubit>().fetchTransactions();
                      Fluttertoast.showToast(
                        msg: "تم إضافة الدخل بنجاح",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      );
                    } else if (state is AddTransactionFailure) {
                      Fluttertoast.showToast(
                        msg: "فشل إضافة الدخل: ${state.message}",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          controller: incomeController,
                          label: "اضف دخلك الان ",
                          hintText: "10000",
                          prefixIcon: Icons.monetization_on,
                          isPassword: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال المبلغ';
                            }
                            final amount = double.tryParse(value);
                            if (amount == null || amount <= 0) {
                              return 'الرجاء إدخال مبلغ صالح أكبر من الصفر';
                            }
                            return null;
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),  

                  SliverGap(20),  

               SliverToBoxAdapter(
                child: BlocBuilder<AddTransactionCubit, AddTransactionState>(
                  builder: (context, state) {
                    if (state is AddTransactionLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return CustomBatton(
                      text: "حفظ",
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          final categoriesState = context
                              .read<CategoriesCubit>()
                              .state;
                          if (categoriesState is! CategoriesLoaded) {
                            Fluttertoast.showToast(
                              msg: 'تعذر تحميل تصنيفات الدخل من الخادم',
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                            return;
                          }

                          final incomeCategories = _incomeCategories(
                            categoriesState.categories,
                          );
                          if (incomeCategories.isEmpty) {
                            Fluttertoast.showToast(
                              msg: 'لا يوجد تصنيف راتب في حسابك. تعذر حفظ الدخل.',
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                            return;
                          }

                          final salaryCategory = _resolveSalaryCategory(
                            incomeCategories,
                          );
                          final amount = double.parse(incomeController.text);
                          context.read<AddTransactionCubit>().addTransaction(
                            type: 'income',
                            categoryId: salaryCategory.id,
                            currencyCode: 'EGP',
                            amount: amount,
                            exchangeRate: 1,
                            baseCurrencyAmount: amount,
                            description: 'دخل',
                            transactionDate: DateTime.now(),
                          );
                        }
                      },
                    );
                  },
                ),
              ), 


              SliverToBoxAdapter(
                child: MonthlyCalendarCard(
                  transactionDates: [
                    DateTime(2026, 10, 2),
                    DateTime(2026, 10, 3),
                    DateTime(2026, 10, 6),
                  ],
                ),
              ),

              SliverGap(10),

              SliverToBoxAdapter(child: AccountBalanceCard()),
              SliverGap(20),

              

              SliverGap(20),

             

             SliverGap(50), 
            ],
          ),
        ),
      ),
    );
  }
}

List<CategoryEntity> _incomeCategories(List<CategoryEntity> categories) {
  const incomeNames = {'راتب', 'salary'};

  return categories.where((category) {
    return incomeNames.contains(_normalizeCategoryName(category.name));
  }).toList();
}

CategoryEntity _resolveSalaryCategory(List<CategoryEntity> categories) {
  for (final category in categories) {
    final normalizedName = _normalizeCategoryName(category.name);
    if (normalizedName == 'راتب' || normalizedName == 'salary') {
      return category;
    }
  }

  return categories.isNotEmpty
      ? categories.first
      : const CategoryEntity(id: '', name: '');
}

String _normalizeCategoryName(String name) {
  return name
      .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
      .toLowerCase()
      .trim();
}
