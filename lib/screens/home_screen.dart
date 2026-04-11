import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';
import 'test_screen.dart';
import 'appointment_screen.dart';
import 'forum/forum_landing_page.dart';
import 'profile_screen.dart';
import 'helpline/helpline_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning,";
    if (hour < 17) return "Good Afternoon,";
    return "Good Evening,";
  }

  Widget _buildCard(BuildContext context, String title, String subtitle, IconData icon, Widget screen, int index) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF03045E)),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.2),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(duration: 400.ms, delay: (100 * index).ms).slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOutQuad);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: user != null
                      ? FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots()
                      : const Stream.empty(),
                  builder: (context, snapshot) {
                    String userName = "";
                    if (snapshot.hasData && snapshot.data!.exists) {
                      Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
                      if (data != null && data.containsKey('name')) {
                         userName = data['name'];
                      }
                    } else if (user != null && user.displayName != null) {
                      userName = user.displayName!;
                    }

                    // Format user name (grab first name only for cleanliness)
                    if (userName.isNotEmpty) {
                       userName = " ${userName.split(' ')[0]}";
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_getGreeting()}$userName",
                                style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                              ).animate().fade().slideX(),
                              const SizedBox(height: 6),
                              const Text(
                                "How are you feeling today?",
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF03045E), height: 1.2),
                              ).animate().fade(delay: 100.ms).slideX(),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                             Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
                          },
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                            child: user?.photoURL == null 
                                ? Icon(Icons.person_outline_rounded, color: Theme.of(context).colorScheme.primary)
                                : null,
                          ).animate().scale(delay: 200.ms),
                        ),
                      ],
                    );
                  }
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  _buildCard(context, "AI Chatbot", "Talk to our AI therapist", Icons.chat_bubble_outline_rounded, ChatScreen(), 0),
                  _buildCard(context, "Tests", "Assess your mental health", Icons.assignment_outlined, TestScreen(), 1),
                   _buildCard(context, "Community", "Connect with others", Icons.people_outline_rounded, ForumLandingPage(), 2),
                  _buildCard(context, "Bookings", "Consult a specialist", Icons.calendar_today_rounded, AppointmentScreen(), 3),
                  _buildCard(context, "Helplines", "Immediate support now", Icons.support_agent_rounded, const HelplineScreen(), 4),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}