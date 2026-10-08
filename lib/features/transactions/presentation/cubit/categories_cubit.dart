import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/features/transactions/domain/entity/usecase/transaction_usecase.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CreateTransactionUseCase transactionUseCase;

  CategoriesCubit(this.transactionUseCase) : super(CategoriesInitial());

  Future<void> loadCategories() async {
    emit(CategoriesLoading());

    final result = await transactionUseCase.getCategories();
    result.fold(
      (failure) => emit(CategoriesFailure(failure.message)),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }
}
