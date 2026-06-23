import '../entities/portfolio_data.dart';

abstract class PortfolioRepository {
  Future<PortfolioData> getPortfolioData();
}
