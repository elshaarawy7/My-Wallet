import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/features/transactions/domain/usecase/transaction_usecase.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/transaction/transaction_state.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  final CreateTransactionUseCase createTransactionUseCase;

  AddTransactionCubit(this.createTransactionUseCase)
    : super(AddTransactionInitial());

  static AddTransactionCubit get(context) => BlocProvider.of(context);

  Future<void> addTransaction({
    required String type,
    required String categoryId,
    required String currencyCode,
    required double amount,
    required double exchangeRate,
    required double baseCurrencyAmount,
    required String description,
    required DateTime transactionDate,
  }) async {
    if (isClosed) return;
    emit(AddTransactionLoading());

    final result = await createTransactionUseCase(
      type: type,
      categoryId: categoryId,
      currencyCode: currencyCode,
      amount: amount,
      exchangeRate: exchangeRate,
      baseCurrencyAmount: baseCurrencyAmount,
      description: description,
      transactionDate: transactionDate,
    );

    if (isClosed) return;
    result.fold(
      (failure) => emit(AddTransactionFailure(failure.message)),
      (transaction) => emit(AddTransactionSuccess(transaction)),
    );
  }
}
