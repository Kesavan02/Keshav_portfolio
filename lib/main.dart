import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme.dart';
import 'features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'features/portfolio/presentation/bloc/portfolio_event.dart';
import 'features/portfolio/presentation/pages/portfolio_page.dart';
import 'injection_container.dart' as di;

import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {
    try {
      await dotenv.load(fileName: "assets/env");
    } catch (_) {}
  }

  final cloudName = dotenv.isInitialized ? (dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '') : '';
  
  // Initialize Cloudinary with Cloud Name from .env if present
  if (cloudName.isNotEmpty) {
    // ignore: deprecated_member_use
    CloudinaryContext.cloudinary = Cloudinary.fromCloudName(cloudName: cloudName);
  }

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
