import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/service_locator.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/diary/presentation/cubit/diary_cubit.dart';
import 'features/diary/presentation/pages/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MindDiaryApp());
}

class MindDiaryApp extends StatelessWidget {
  const MindDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<DiaryCubit>()..loadEntries(),
      child: MaterialApp(
        title: 'MindDiary',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const OnboardingPage(),
      ),
    );
  }
}
