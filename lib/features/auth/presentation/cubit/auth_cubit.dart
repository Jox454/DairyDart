import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  void checkAuth() {
    final userId = _authRepository.currentUserId;
    if (userId != null) {
      emit(Authenticated(userId));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authRepository.signIn(email: email, password: password);
      final userId = _authRepository.currentUserId;
      if (userId != null) {
        emit(Authenticated(userId));
      } else {
        emit(Unauthenticated());
      }
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        emit(const AuthError("No account found with this email or incorrect password."));
      } else {
        emit(AuthError(e.message));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(email: email, password: password);
      final userId = _authRepository.currentUserId;
      if (userId != null) {
        emit(Authenticated(userId));
      } else {
        emit(const AuthError("Registration successful. Please check your email for confirmation."));
      }
    } on AuthException catch (e) {
      if (e.message.contains('User already registered')) {
        emit(const AuthError("An account with this email already exists."));
      } else {
        emit(AuthError(e.message));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void continueAsGuest() {
    emit(GuestMode());
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(Unauthenticated());
  }
}
