import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/portfolio_repository.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final PortfolioRepository repository;

  PortfolioBloc({required this.repository}) : super(PortfolioInitial()) {
    on<LoadPortfolioData>(_onLoadPortfolioData);
  }

  Future<void> _onLoadPortfolioData(
    LoadPortfolioData event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(PortfolioLoading());
    try {
      final data = await repository.getPortfolioData();
      emit(PortfolioLoaded(portfolioData: data));
    } catch (e) {
      emit(PortfolioError(message: 'Failed to load portfolio data: ${e.toString()}'));
    }
  }
}
