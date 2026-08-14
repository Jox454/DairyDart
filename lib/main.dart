import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'core/di/service_locator.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/diary/presentation/cubit/diary_cubit.dart';
import 'features/diary/presentation/pages/onboarding_page.dart';
import 'features/diary/presentation/pages/dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://rqrcraitrmifsuzuxxxs.supabase.co',
    anonKey: 'sb_publishable_MQu4oGD65unNdHWCJx2xLQ_eQpnNzxX',
  );

  await di.init();
  runApp(const MindDiaryApp());
}

class MindDiaryApp extends StatelessWidget {
  const MindDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..checkAuth()),
        BlocProvider(create: (_) => di.sl<DiaryCubit>()..loadEntries()),
      ],
      child: MaterialApp(
        title: 'MindDiary',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is Authenticated || state is GuestMode) {
              return const DashboardPage();
            }
            return const OnboardingPage();
          },
        ),
      ),
    );
  }
}
