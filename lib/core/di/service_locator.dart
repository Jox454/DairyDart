import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/supabase_auth_repository_impl.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/diary/domain/repositories/diary_repository.dart';
import '../../features/diary/domain/usecases/get_mood_entries.dart';
import '../../features/diary/domain/usecases/add_mood_entry.dart';
import '../../features/diary/domain/usecases/delete_mood_entry.dart';
import '../../features/diary/domain/usecases/update_mood_entry.dart';
import '../../features/diary/data/repositories/supabase_diary_repository_impl.dart';
import '../../features/diary/presentation/cubit/diary_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Supabase
  sl.registerLazySingleton(() => Supabase.instance.client);

  // Features - Auth
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerLazySingleton<AuthRepository>(() => SupabaseAuthRepositoryImpl(sl()));

  // Features - Diary

  // Cubit
  sl.registerFactory(
    () => DiaryCubit(
      getMoodEntries: sl(),
      addMoodEntry: sl(),
      deleteMoodEntry: sl(),
      updateMoodEntry: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMoodEntries(sl()));
  sl.registerLazySingleton(() => AddMoodEntry(sl()));
  sl.registerLazySingleton(() => DeleteMoodEntry(sl()));
  sl.registerLazySingleton(() => UpdateMoodEntry(sl()));

  // Repository
  sl.registerLazySingleton<DiaryRepository>(
    () => SupabaseDiaryRepositoryImpl(sl()),
  );
}
