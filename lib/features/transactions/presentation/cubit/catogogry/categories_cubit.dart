import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/features/transactions/domain/usecase/get_categories_use_case.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/catogogry/categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoriesCubit(this.getCategoriesUseCase) : super(CategoriesInitial());

  Future<void> loadCategories() async {
    emit(CategoriesLoading());

    final result = await getCategoriesUseCase();
    result.fold(
      (failure) => emit(CategoriesFailure(failure.message)),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }
}
