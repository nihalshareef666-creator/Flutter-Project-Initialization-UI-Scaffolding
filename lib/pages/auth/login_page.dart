import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testpro26/main.dart';
import 'package:provider/provider.dart';
import 'package:testpro26/providers/auth_provider.dart';
import 'package:testpro26/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(text: 'admin@pro26.com');
  final TextEditingController _passwordController = TextEditingController(text: 'password');
  
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;
  
  // Animation for logo
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // Animation for button press
  double _buttonScale = 1.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    // Rebuild on focus changes to render shadows & color highlights
    _emailFocusNode.addListener(() { setState(() {}); });
    _passwordFocusNode.addListener(() { setState(() {}); });
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) {
       return;
    }
    
    setState(() => _isLoading = true);
    
    // Convert email to lowercase for consistent handling
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;
    
    final success = await _authService.login(email, password);
    
    if (mounted) {
      setState(() => _isLoading = false);
      
      if (!success) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Text('Invalid email or password'),
             backgroundColor: AppColors.error,
             behavior: SnackBarBehavior.floating,
           ),
         );
         return;
      }
      
      await Provider.of<AuthProvider>(context, listen: false).login(email);
      // Navigate to Dashboard using pushReplacement so user can't navigate back to login
      context.pushReplacement('/dashboard');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Regex for basic email validation
  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  }

  Widget _buildTextFieldContainer({required Widget child, required bool isFocused}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isFocused 
          ? [BoxShadow(color: AppColors.primary.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4))]
          : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo Section with Animation
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.storefront,
                              size: 72,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'TechPlumb Solutions',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sign in to continue to your dashboard',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Middle Section (Inputs)
                  _buildTextFieldContainer(
                    isFocused: _emailFocusNode.hasFocus,
                    child: TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email_outlined, 
                          color: _emailFocusNode.hasFocus ? AppColors.primary : AppColors.textHint,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.error, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!_isValidEmail(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildTextFieldContainer(
                    isFocused: _passwordFocusNode.hasFocus,
                    child: TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        prefixIcon: Icon(Icons.lock_outline,
                          color: _passwordFocusNode.hasFocus ? AppColors.primary : AppColors.textHint,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.error, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bottom Section
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Animated Gradient Login Button
                  GestureDetector(
                    onTapDown: _isLoading ? null : (_) => setState(() => _buttonScale = 0.96),
                    onTapUp: _isLoading ? null : (_) => setState(() => _buttonScale = 1.0),
                    onTapCancel: _isLoading ? null : () => setState(() => _buttonScale = 1.0),
                    onTap: _isLoading ? null : _login,
                    child: AnimatedScale(
                      scale: _buttonScale,
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primaryLight,
                              AppColors.primaryDark,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Temporary Mock bypass Button
                  TextButton.icon(
                    onPressed: () => context.pushReplacement('/dashboard'),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Skip Login (Mock purpose only)'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                      InkWell(
                        onTap: () => context.push('/signup'),
                        borderRadius: BorderRadius.circular(4),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
