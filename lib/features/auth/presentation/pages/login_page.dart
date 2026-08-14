import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../diary/presentation/widgets/glass_card.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            left: -100,
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
                          const SizedBox(height: 40),
                          Text(
                            "Welcome Back",
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Sign in to continue your journey",
                            style: TextStyle(color: AppColors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 48),
                          // Email
                          const Text("Email", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 12),
                          GlassCard(
                            borderRadius: 16,
                            padding: EdgeInsets.zero,
                            child: TextFormField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: "your@email.com",
                                hintStyle: TextStyle(color: AppColors.outline),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
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
                              decoration: const InputDecoration(
                                hintText: "••••••••",
                                hintStyle: TextStyle(color: AppColors.outline),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                              ),
                              validator: (v) => (v == null || v.isEmpty) ? 'Please enter your password' : null,
                            ),
                          ),
                          const SizedBox(height: 48),
                          // Login Button
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
                                            context.read<AuthCubit>().signIn(
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
                                      : const Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ),
                              );
                            },
                          ),
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
