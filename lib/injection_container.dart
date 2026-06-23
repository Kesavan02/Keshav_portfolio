import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/portfolio/data/datasources/local_data_source.dart';
import 'features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'features/portfolio/domain/repositories/portfolio_repository.dart';
import 'features/portfolio/presentation/bloc/portfolio_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(() => PortfolioBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PortfolioLocalDataSource>(
    () => PortfolioLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}
