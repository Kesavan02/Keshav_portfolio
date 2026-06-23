import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme.dart';
import 'features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'features/portfolio/presentation/bloc/portfolio_event.dart';
import 'features/portfolio/presentation/pages/portfolio_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize DI

  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<PortfolioBloc>()..add(LoadPortfolioData()),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Kesavan - Flutter Developer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.backgroundDark,
          primaryColor: AppColors.primaryGlow,
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          useMaterial3: true,
        ),
        home: const PortfolioPage(),
      ),
    );
  }
}
