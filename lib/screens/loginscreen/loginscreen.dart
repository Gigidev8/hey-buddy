import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:schoola_buddy/functions/auth/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideUpAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideUpAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleGoogleSignIn() async {
    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
      if (next.user != null && previous?.user == null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.8,
                colors: [
                  Colors.grey.shade900.withOpacity(0.6),
                  Colors.black,
                ],
              ),
            ),
          ),

          // Dot pattern
          Positioned.fill(
            child: CustomPaint(
              painter: DotPatternPainter(),
            ),
          ),

          // Glowing elements
          Positioned(
            top: -size.height * 0.15,
            left: -size.width * 0.1,
            child: _buildGlow(size.width * 0.7, Colors.blueAccent),
          ),
          Positioned(
            bottom: -size.height * 0.05,
            right: -size.width * 0.15,
            child: _buildGlow(size.width * 0.6, Colors.greenAccent),
          ),

          // Circuit lines
          Positioned.fill(
            child: CustomPaint(
              painter: CircuitLinesPainter(
                progress: _fadeInAnimation.value,
                repaint: _animationController, // Pass controller as Listenable
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // Logo
                  FadeTransition(
                    opacity: _fadeInAnimation,
                    child: _buildLogo(),
                  ),
                  const SizedBox(height: 24),

                  // App Name
                  SlideTransition(
                    position: _slideUpAnimation,
                    child: FadeTransition(
                      opacity: _fadeInAnimation,
                      child: const Text(
                        "Hey Buddy!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tagline
                  SlideTransition(
                    position: _slideUpAnimation,
                    child: FadeTransition(
                      opacity: _fadeInAnimation,
                      child: Text(
                        "Your personal campus guide",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Lottie animation
                  Expanded(
                    child: Center(
                      child: FadeTransition(
                        opacity: _fadeInAnimation,
                        child: Lottie.asset(
                          'assets/lottie/studying.json',
                          width: size.width * 0.8,
                          height: size.width * 0.8,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Sign-in button
                  SlideTransition(
                    position: _slideUpAnimation,
                    child: FadeTransition(
                      opacity: _fadeInAnimation,
                      child: authState.isLoading
                          ? _buildLoadingButton()
                          : _buildGoogleSignInButton(),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // App version
                  FadeTransition(
                    opacity: _fadeInAnimation,
                    child: _buildVersionTag(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.school_rounded, size: 40, color: Colors.white),
      ),
    );
  }

  Widget _buildGlow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.15),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleGoogleSignIn,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo/google.png', width: 24, height: 24),
              const SizedBox(width: 12),
              const Text(
                "Sign in with Google",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildVersionTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "Version 1.0.0",
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 12,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

// Dot Pattern Painter
class DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    const dotSize = 1.5;
    const spacing = 25.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Circuit Lines Painter
class CircuitLinesPainter extends CustomPainter {
  final double progress;

  CircuitLinesPainter({required this.progress, required Listenable repaint})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.1) return;

    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path();

    path.moveTo(0, size.height * 0.3);
    path.lineTo(size.width * 0.15, size.height * 0.3);
    path.lineTo(size.width * 0.15, size.height * 0.5);
    path.lineTo(size.width * 0.25, size.height * 0.5);

    path.moveTo(size.width, size.height * 0.7);
    path.lineTo(size.width * 0.85, size.height * 0.7);
    path.lineTo(size.width * 0.85, size.height * 0.5);
    path.lineTo(size.width * 0.75, size.height * 0.5);

    path.moveTo(size.width * 0.4, 0);
    path.lineTo(size.width * 0.4, size.height * 0.15);
    path.lineTo(size.width * 0.6, size.height * 0.15);
    path.lineTo(size.width * 0.6, 0);

    path.moveTo(size.width * 0.4, size.height);
    path.lineTo(size.width * 0.4, size.height * 0.85);
    path.lineTo(size.width * 0.6, size.height * 0.85);
    path.lineTo(size.width * 0.6, size.height);

    canvas.drawPath(path, paint);

    final dotPaint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final points = [
      Offset(size.width * 0.15, size.height * 0.3),
      Offset(size.width * 0.85, size.height * 0.7),
      Offset(size.width * 0.25, size.height * 0.5),
      Offset(size.width * 0.75, size.height * 0.5),
      Offset(size.width * 0.4, size.height * 0.15),
      Offset(size.width * 0.6, size.height * 0.15),
      Offset(size.width * 0.4, size.height * 0.85),
      Offset(size.width * 0.6, size.height * 0.85),
    ];

    for (final point in points) {
      canvas.drawCircle(point, 3.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CircuitLinesPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
