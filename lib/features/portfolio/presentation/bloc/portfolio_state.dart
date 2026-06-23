import 'package:equatable/equatable.dart';
import '../../domain/entities/portfolio_data.dart';

abstract class PortfolioState extends Equatable {
  const PortfolioState();
  
  @override
  List<Object> get props => [];
}

class PortfolioInitial extends PortfolioState {}

class PortfolioLoading extends PortfolioState {}

class PortfolioLoaded extends PortfolioState {
  final PortfolioData portfolioData;

  const PortfolioLoaded({required this.portfolioData});

  @override
  List<Object> get props => [portfolioData];
}

class PortfolioError extends PortfolioState {
  final String message;

  const PortfolioError({required this.message});

  @override
  List<Object> get props => [message];
}
