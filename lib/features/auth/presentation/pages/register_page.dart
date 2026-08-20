import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../diary/presentation/widgets/glass_card.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    if (value.length > 12) return 'Password must be at most 12 characters';
    
    final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
    if (!alphanumeric.hasMatch(value)) {
      return 'Only letters and numbers allowed (no special characters)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            right: -100,
            top: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Text(
                            "Create Account",
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Join MindDiary and sync your feelings across devices",
                            style: TextStyle(color: AppColors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 40),
                          // Email
                          const Text("Email", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 12),
                          GlassCard(
                            borderRadius: 16,
                            padding: EdgeInsets.zero,
                            child: TextFormField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.white),
                              maxLength: 25,
                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              decoration: const InputDecoration(
                                hintText: "your@email.com",
                                helperText: "Max 25 characters",
                                helperStyle: TextStyle(color: AppColors.outline, fontSize: 10),
                                hintStyle: TextStyle(color: AppColors.outline),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                                counterText: "",
                              ),
                              validator: _validateEmail,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Password
                          const Text("Password", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 12),
                          GlassCard(
                            borderRadius: 16,
                            padding: EdgeInsets.zero,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              maxLength: 12,
                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                              ],
                              decoration: const InputDecoration(
                                hintText: "••••••••",
                                hintStyle: TextStyle(color: AppColors.outline),
                                helperText: "Letters and numbers only (max 12)",
                                helperStyle: TextStyle(color: AppColors.outline, fontSize: 10),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                                counterText: "",
                              ),
                              validator: _validatePassword,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Confirm Password
                          const Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 12),
                          GlassCard(
                            borderRadius: 16,
                            padding: EdgeInsets.zero,
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              maxLength: 12,
                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                              ],
                              decoration: const InputDecoration(
                                hintText: "Repeat your password",
                                hintStyle: TextStyle(color: AppColors.outline),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                                counterText: "",
                              ),
                              validator: (v) {
                                if (v != _passwordController.text) return 'Passwords do not match';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 48),
                          // Register Button
                          BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is AuthError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
                                );
                              }
                            },
                            builder: (context, state) {
                              return SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: state is AuthLoading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!.validate()) {
                                            context.read<AuthCubit>().signUp(
                                                  _emailController.text.trim(),
                                                  _passwordController.text.trim(),
                                                );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  child: state is AuthLoading
                                      ? const CircularProgressIndicator(color: Colors.black)
                                      : const Text("Create Account", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
