import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final AuthService authService = AuthService();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(color: Color(0xFF03045E), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF03045E), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: user != null 
            ? FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots()
            : const Stream.empty(),
        builder: (context, snapshot) {
          String name = "User";
          String email = user?.email ?? "";
          String age = "N/A";
          String role = "User";

          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>?;
            if (data != null) {
              name = data['name'] ?? name;
              age = data['age']?.toString() ?? age;
              role = data['role']?.toUpperCase() ?? role;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2), width: 4),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                          child: user?.photoURL == null 
                              ? Icon(Icons.person_rounded, size: 60, color: Theme.of(context).colorScheme.primary)
                              : null,
                        ),
                      ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
                        ),
                      ).animate().scale(delay: 400.ms),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  name,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF03045E)),
                ).animate().fade().slideY(begin: 0.2),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    role,
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ).animate().fade(delay: 200.ms),
                const SizedBox(height: 40),
                _buildInfoTile(Icons.email_outlined, "Email Address", email, context, 0),
                _buildInfoTile(Icons.cake_outlined, "Age", age, context, 1),
                const SizedBox(height: 40),
                SizedBox(
                   width: double.infinity,
                   height: 56,
                   child: ElevatedButton.icon(
                    onPressed: () async {
                      await authService.signOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context, 
                          MaterialPageRoute(builder: (_) => const LoginScreen()), 
                          (route) => false
                        );
                      }
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text("Log Out", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(color: Colors.red.shade100),
                    ),
                   ),
                ).animate().fade(delay: 600.ms).slideY(begin: 0.2),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value, BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF03045E))),
            ],
          ),
        ],
      ),
    ).animate().fade(delay: (300 + (100 * index)).ms).slideX(begin: 0.1);
  }
}