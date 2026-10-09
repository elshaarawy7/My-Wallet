import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/features/transactions/domain/usecase/delete_transaction_use_case.dart';
import 'package:my_wallet/features/transactions/domain/usecase/get_transaction_use_case.dart';
import 'package:my_wallet/features/transactions/domain/usecase/get_transactions_use_case.dart';
import 'package:my_wallet/features/transactions/domain/usecase/transaction_usecase.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/get_transaction/get_transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final GetTransactionByIdUseCase getTransactionByIdUseCase;
  final GetTransactionsUseCase getTransactionsUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;
  final CreateTransactionUseCase createTransactionUseCase;

  TransactionCubit(
    this.getTransactionByIdUseCase,
    this.getTransactionsUseCase,
    this.deleteTransactionUseCase,
    this.createTransactionUseCase,
  ) : super(TransactionInitial());

  static TransactionCubit get(context) => BlocProvider.of(context);

  Future<void> fetchTransactions() async {
    emit(TransactionLoading());

    final result = await getTransactionsUseCase();
    final transactions = result.fold((failure) {
      emit(TransactionError(failure.message));
      return null;
    }, (transactions) => transactions);
    if (transactions == null) {
      return;
    }
    transactions.sort(
      (first, second) =>
          second.transactionDate.compareTo(first.transactionDate),
    );

    final categoriesResult = await createTransactionUseCase.getCategories();
    String? categoryErrorMessage;
    final categoriesById = categoriesResult.fold(
      (failure) {
        categoryErrorMessage = failure.message;
        return <String, String>{};
      },
      (categories) => {
        for (final category in categories) category.id: category.name,
      },
    );
    emit(
      TransactionsLoaded(
        transactions,
        categoriesById: categoriesById,
        categoryErrorMessage: categoryErrorMessage,
      ),
    );
  }

  Future<void> deleteTransaction(String id) async {
    emit(TransactionDeleting());

    final result = await deleteTransactionUseCase(id);
    result.fold(
      (failure) => emit(TransactionDeleteFailure(failure.message)),
      (_) => emit(TransactionDeleted()),
    );
  }

  Future<void> fetchTransaction(String id) async {
    emit(TransactionLoading());

    final result = await getTransactionByIdUseCase(id);

    result.fold(
      (failure) => emit(TransactionError(failure.message)),
      (transaction) => emit(TransactionLoaded(transaction)),
    );
  }
}
