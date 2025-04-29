import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:schoola_buddy/screens/loginscreen/loginscreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> with TickerProviderStateMixin {
  late AnimationController _bubbleController;
  late Animation<double> _bubbleScale;
  late AnimationController _lottieController;

  // Logo animations
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  // Text animations
  late AnimationController _textController;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide; // ✅ Corrected type here!

  @override
  void initState() {
    super.initState();

    // Bubble animation
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _bubbleScale = Tween<double>(begin: 1.0, end: 20.0).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.fastOutSlowIn),
    );

    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)),
    );

    // Text animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    // Lottie animation
    _lottieController = AnimationController(vsync: this);

    // Animation sequence setup
    _logoController.forward();
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _textController.forward();
        _lottieController.forward();
      }
    });

    _lottieController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _bubbleController.forward();
      }
    });

    _bubbleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    _lottieController.dispose();
    _textController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Colors.grey.shade900.withOpacity(0.5),
                  Colors.black,
                ],
              ),
            ),
          ),

          // Dot Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: DotPatternPainter(),
            ),
          ),

          // Left Glow
          Positioned(
            left: -100,
            top: MediaQuery.of(context).size.height * 0.3,
            child: ScaleTransition(
              scale: _bubbleScale,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.blueAccent.withOpacity(0.3),
                      Colors.blue.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Right Glow
          Positioned(
            right: -80,
            bottom: MediaQuery.of(context).size.height * 0.35,
            child: ScaleTransition(
              scale: _bubbleScale,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.greenAccent.withOpacity(0.2),
                      Colors.blue.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Center Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                FadeTransition(
                  opacity: _logoOpacity,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white24,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.school_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // App Name
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textOpacity,
                    child: Column(
                      children: [
                        const Text(
                          "Hey Buddy!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Your campus, simplified",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lottie Animation
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _textOpacity,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Lottie.asset(
                        "assets/lottie/studentload.json",
                        controller: _lottieController,
                        onLoaded: (composition) {
                          _lottieController.duration = composition.duration;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "by QuadCoders",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Circuit Lines
          Positioned.fill(
            child: CustomPaint(
              painter: CircuitLinesPainter(
                progress: _logoScale.value,
                repaint: _logoController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Dot pattern background
class DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final dotSize = 2.0;
    final spacing = 20.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Circuit lines animation
class CircuitLinesPainter extends CustomPainter {
  final double progress;
  final Animation<double> repaint;

  CircuitLinesPainter({required this.progress, required this.repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.1) return;

    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);

    final path = Path();

    // Circuit lines
    path.moveTo(center.dx - 50, center.dy);
    path.lineTo(center.dx - 100, center.dy);
    path.lineTo(center.dx - 100, center.dy - 100);
    path.lineTo(0, center.dy - 100);

    path.moveTo(center.dx + 50, center.dy);
    path.lineTo(center.dx + 100, center.dy);
    path.lineTo(center.dx + 100, center.dy + 100);
    path.lineTo(size.width, center.dy + 100);

    path.moveTo(center.dx, center.dy - 50);
    path.lineTo(center.dx, center.dy - 150);
    path.lineTo(center.dx + 50, center.dy - 150);
    path.lineTo(center.dx + 50, 0);

    path.moveTo(center.dx, center.dy + 50);
    path.lineTo(center.dx, center.dy + 150);
    path.lineTo(center.dx - 50, center.dy + 150);
    path.lineTo(center.dx - 50, size.height);

    canvas.drawPath(path, paint);

    // Glowing dots at ends
    final dotPaint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(0, center.dy - 100), 3.0, dotPaint);
    canvas.drawCircle(Offset(size.width, center.dy + 100), 3.0, dotPaint);
    canvas.drawCircle(Offset(center.dx + 50, 0), 3.0, dotPaint);
    canvas.drawCircle(Offset(center.dx - 50, size.height), 3.0, dotPaint);
  }

  @override
  bool shouldRepaint(CircuitLinesPainter oldDelegate) => progress != oldDelegate.progress;
}
