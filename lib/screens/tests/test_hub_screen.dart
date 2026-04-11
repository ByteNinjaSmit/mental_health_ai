import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'mood_check_screen.dart';
import 'diagnostic_quiz_screen.dart';
import 'insights_screen.dart';

class TestHubScreen extends StatelessWidget {
  const TestHubScreen({super.key});

  Widget _buildTestCard(
      BuildContext context, String title, String subtitle, IconData icon, Color color, Widget screen, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100, width: 2),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF03045E))),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.3)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade300),
            ],
          ),
        ),
      ),
    ).animate().fade(delay: (index * 100).ms).slideY(begin: 0.2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Assessment Hub"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InsightsScreen())),
            icon: const Icon(Icons.auto_awesome_rounded, color: Colors.amber),
            tooltip: "AI Insights",
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Banner for Insights
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.show_chart_rounded, color: Color(0xFF03045E), size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Mental Health Trends", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF03045E))),
                      Text("See how your well-being has evolved.", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InsightsScreen())),
                  child: const Text("Explore"),
                ),
              ],
            ),
          ).animate().fade().slideY(begin: -0.2),
          const SizedBox(height: 32),
          const Text(
            "Check-in with yourself",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF03045E)),
          ),
          const SizedBox(height: 8),
          Text(
            "Choose a quick test or a detailed assessment to monitor your well-being.",
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.5),
          ),
          const SizedBox(height: 32),
          _buildTestCard(
            context,
            "Interactive Mood Check",
            "Express your feelings using our big interactive emojis.",
            Icons.face_retouching_natural_rounded,
            Colors.orange,
            const MoodCheckScreen(),
            0,
          ),
          _buildTestCard(
            context,
            "Anxiety Assessment",
            "A gentle check-in for anxiety and nervousness levels.",
            Icons.psychology_rounded,
            Colors.blue,
            const DiagnosticQuizScreen(type: "anxiety"),
            1,
          ),
          _buildTestCard(
            context,
            "Depression Screening",
            "A safe space to assess persistent sadness or low energy.",
            Icons.self_improvement_rounded,
            Colors.purple,
            const DiagnosticQuizScreen(type: "depression"),
            2,
          ),
          _buildTestCard(
            context,
            "Stress Level Test",
            "Quick test to see how you are handling life's pressure.",
            Icons.bolt_rounded,
            Colors.redAccent,
            const DiagnosticQuizScreen(type: "stress"),
            3,
          ),
        ],
      ),
    );
  }
}
