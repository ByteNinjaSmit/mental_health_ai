import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.psychology_rounded, size: 80, color: Theme.of(context).colorScheme.primary),
            ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack, duration: 600.ms),
            const SizedBox(height: 24),
            const Text(
              "Mental Health AI",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF03045E), letterSpacing: -1),
            ).animate().fade(delay: 400.ms).slideY(begin: 0.2),
            const SizedBox(height: 12),
            Text(
              "Your personalized 24/7 companion.",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ).animate().fade(delay: 600.ms),
          ],
        ),
      ),
    );
  }
}