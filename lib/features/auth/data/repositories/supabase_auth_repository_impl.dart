import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/auth_repository.dart';

class SupabaseAuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase;

  SupabaseAuthRepositoryImpl(this._supabase);

  @override
  Future<void> signUp({required String email, required String password}) async {
    await _supabase.auth.signUp(email: email, password: password);
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  @override
  String? get currentUserId => _supabase.auth.currentUser?.id;
}
