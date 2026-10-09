import 'package:dartz/dartz.dart';
import 'package:my_wallet/core/errors/fuiler.dart';
import 'package:my_wallet/features/transactions/data/models/get_transaction_model.dart';
import 'package:my_wallet/features/transactions/domain/entity/transaction_entity.dart';
import 'package:my_wallet/features/transactions/domain/repositories/transactions_repo.dart';


class GetTransactionByIdUseCase {
  final TransactionRepository repository;

  GetTransactionByIdUseCase(this.repository);

  Future<Either<Failure, GetTransactionModel>> call(String id) async {
    return await repository.getTransactionById(id);
  }
}