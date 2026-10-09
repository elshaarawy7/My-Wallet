import 'package:dartz/dartz.dart';
import 'package:my_wallet/core/errors/fuiler.dart';
import 'package:my_wallet/features/transactions/domain/entity/category_entity.dart';
import 'package:my_wallet/features/transactions/domain/repositories/transactions_repo.dart';

class GetCategoriesUseCase {
  final TransactionRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return repository.getCategories();
  }
}
