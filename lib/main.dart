import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00B4D8), 
          primary: const Color(0xFF0077B6),
          secondary: const Color(0xFF90E0EF),
          surface: const Color(0xFFF8F9FA),
        ),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF03045E)),
          titleTextStyle: TextStyle(
            color: Color(0xFF03045E),
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0077B6),
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: const Color(0xFF0077B6).withOpacity(0.4),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF00B4D8), width: 2),
          ),
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data != null) {
              return const HomeScreen();
            }
            return const SplashScreen();
          }
          return Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor, body: const Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}