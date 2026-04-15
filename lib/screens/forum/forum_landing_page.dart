import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../topics_page.dart';
import '../resources/resource_home_screen.dart';

class ForumLandingPage extends StatelessWidget {
  final List<String> categories = const [
    'Anxiety',
    'Depression',
    'PTSD',
    'OCD',
    'Stress',
    'Bipolar',
    'Miscellaneous'
  ];

  const ForumLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Community"),
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey.shade500,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            unselectedLabelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            tabs: const [
              Tab(
                icon: Icon(Icons.forum_rounded),
                text: "Forum",
              ),
              Tab(
                icon: Icon(Icons.library_books_rounded),
                text: "Resources",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ── Tab 1: Forum Categories ──
            _ForumCategoriesTab(categories: categories),
            // ── Tab 2: Resources ──
            const ResourceHomeScreen(),
          ],
        ),
      ),
    );
  }
}

class _ForumCategoriesTab extends StatelessWidget {
  final List<String> categories;

  const _ForumCategoriesTab({required this.categories});

  static const _categoryIcons = {
    'Anxiety': Icons.psychology_rounded,
    'Depression': Icons.self_improvement_rounded,
    'PTSD': Icons.healing_rounded,
    'OCD': Icons.autorenew_rounded,
    'Stress': Icons.bolt_rounded,
    'Bipolar': Icons.swap_vert_rounded,
    'Miscellaneous': Icons.category_rounded,
  };

  static const _categoryColors = {
    'Anxiety': Color(0xFF5C6BC0),
    'Depression': Color(0xFF7E57C2),
    'PTSD': Color(0xFFEF5350),
    'OCD': Color(0xFF26A69A),
    'Stress': Color(0xFFFFA726),
    'Bipolar': Color(0xFF42A5F5),
    'Miscellaneous': Color(0xFF78909C),
  };

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: categories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final cat = categories[index];
        final color = _categoryColors[cat] ?? Colors.blueAccent;
        final icon = _categoryIcons[cat] ?? Icons.chat_bubble_outline_rounded;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            title: Text(
              cat,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF03045E)),
            ),
            subtitle: Text(
              "Join the discussion",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade300),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TopicsPage(category: cat),
                ),
              );
            },
          ),
        ).animate().fade(delay: (50 * index).ms).slideX(begin: 0.05, curve: Curves.easeOut);
      },
    );
  }
}