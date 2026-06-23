import '../../domain/entities/portfolio_data.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/local_data_source.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioLocalDataSource localDataSource;

  PortfolioRepositoryImpl({required this.localDataSource});

  @override
  Future<PortfolioData> getPortfolioData() async {
    return await localDataSource.getPortfolioData();
  }
}
