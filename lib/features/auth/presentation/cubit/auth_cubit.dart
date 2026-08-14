import 'package:flutter_bloc/flutter_bloc.dart';
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
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(email: email, password: password);
      // Supabase usually sends confirmation email, but if disabled, it signs in automatically or needs signIn call.
      // Assuming auto-confirm or just waiting for them to sign in.
      // If confirm is off, session is usually active.
      final userId = _authRepository.currentUserId;
      if (userId != null) {
        emit(Authenticated(userId));
      } else {
        emit(const AuthError("Registration successful. Please sign in."));
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
