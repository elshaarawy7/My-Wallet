import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_wallet/core/network/dio_client.dart';
import 'package:my_wallet/features/auth/data/datasources/datasources_auth_imple.dart';
import 'package:my_wallet/features/auth/data/repositories/auth_repo_imple.dart';
import 'package:my_wallet/features/auth/domain/repositories/auth_repo.dart';
import 'package:my_wallet/features/auth/presentation/cubit/google/googole_cubit.dart';
import 'package:my_wallet/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:my_wallet/features/auth/presentation/cubit/regester/regester_cubit.dart';
import 'package:my_wallet/features/transactions/data/datasources/transaction_datasource_imple.dart';
import 'package:my_wallet/features/transactions/data/repositories/transactions_repo_imple.dart';
import 'package:my_wallet/features/transactions/domain/repositories/transactions_repo.dart';
import 'package:my_wallet/features/transactions/domain/usecase/get_transaction_use_case.dart';
import 'package:my_wallet/features/transactions/domain/usecase/get_transactions_use_case.dart';
import 'package:my_wallet/features/transactions/domain/usecase/delete_transaction_use_case.dart';
import 'package:my_wallet/features/transactions/domain/usecase/get_categories_use_case.dart';
import 'package:my_wallet/features/transactions/domain/usecase/transaction_usecase.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/catogogry/categories_cubit.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/get_transaction/get_transaction_cubit.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/transaction/transaction_cubit.dart';

final gitIt = GetIt.instance;

void setupServer() {
  // Register GoogleSignIn first so it can be injected into DatasourcesAuthImple
  gitIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);
  gitIt.registerLazySingleton<Dio>(() => DioClient().dio);
  gitIt.registerLazySingleton<DatasourcesAuthImple>(
    () => DatasourcesAuthImple(gitIt<Dio>(), gitIt<GoogleSignIn>()),
  );
  gitIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImple(gitIt<DatasourcesAuthImple>()),
  );
  gitIt.registerLazySingleton<LoginCubit>(
    () => LoginCubit(gitIt<AuthRepo>()),
  );

  gitIt.registerLazySingleton<RegesterCubit>(
    () => RegesterCubit(gitIt<AuthRepo>()),
  );

  gitIt.registerLazySingleton<GoogoleCubit>(
    () => GoogoleCubit(gitIt<AuthRepo>()),
  );

  // Transactions
  gitIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      remoteDataSource: gitIt<TransactionRemoteDataSourceImpl>(),
    ),
  );

  gitIt.registerLazySingleton<CreateTransactionUseCase>(
    () => CreateTransactionUseCase(gitIt<TransactionRepository>()),
  );

  gitIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(gitIt<TransactionRepository>()),
  );

  gitIt.registerFactory<AddTransactionCubit>(
    () => AddTransactionCubit(gitIt<CreateTransactionUseCase>()),
  );

  gitIt.registerFactory<CategoriesCubit>(
    () => CategoriesCubit(gitIt<GetCategoriesUseCase>()),
  );

  gitIt.registerLazySingleton<TransactionRemoteDataSourceImpl>(
    () => TransactionRemoteDataSourceImpl(dio: gitIt<Dio>()),
  );  

  gitIt.registerLazySingleton<GetTransactionByIdUseCase>(
    () => GetTransactionByIdUseCase(gitIt<TransactionRepository>()),
  );

  gitIt.registerLazySingleton<GetTransactionsUseCase>(
    () => GetTransactionsUseCase(gitIt<TransactionRepository>()),
  );

  gitIt.registerLazySingleton<DeleteTransactionUseCase>(
    () => DeleteTransactionUseCase(gitIt<TransactionRepository>()),
  );

  gitIt.registerFactory<TransactionCubit>(
    () => TransactionCubit(
      gitIt<GetTransactionByIdUseCase>(),
      gitIt<GetTransactionsUseCase>(),
      gitIt<DeleteTransactionUseCase>(),
      gitIt<GetCategoriesUseCase>(),
    ),
  );



}
