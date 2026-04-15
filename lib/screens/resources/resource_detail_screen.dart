import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/resource_service.dart';
import 'literature_screen.dart';
import 'exercise_screen.dart';
import 'video_channels_screen.dart';
import 'games_screen.dart';
import 'websites_screen.dart';

class ResourceDetailScreen extends StatelessWidget {
  final String category;
  final Color categoryColor;

  const ResourceDetailScreen({
    super.key,
    required this.category,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final resourceTypes = <_ResourceType>[
      if (ResourceDataService.hasLiterature(category))
        _ResourceType(
          title: 'Literature',
          subtitle: 'Books & reading material',
          icon: Icons.menu_book_rounded,
          color: const Color(0xFF5C6BC0),
          screen: LiteratureScreen(category: category),
        ),
      if (ResourceDataService.hasExercises(category))
        _ResourceType(
          title: 'Exercises',
          subtitle: 'Videos & articles for practice',
          icon: Icons.fitness_center_rounded,
          color: const Color(0xFF26A69A),
          screen: ExerciseScreen(category: category),
        ),
      if (ResourceDataService.hasVideos(category))
        _ResourceType(
          title: 'Videos',
          subtitle: 'Recommended YouTube channels',
          icon: Icons.subscriptions_rounded,
          color: const Color(0xFFEF5350),
          screen: VideoChannelsScreen(category: category),
        ),
      if (ResourceDataService.hasGames(category))
        _ResourceType(
          title: 'Games & Activities',
          subtitle: 'Calming games & creative tools',
          icon: Icons.sports_esports_rounded,
          color: const Color(0xFFFFA726),
          screen: GamesScreen(category: category),
        ),
      if (ResourceDataService.hasWebsites(category))
        _ResourceType(
          title: 'Websites & Trusted Sources',
          subtitle: 'Verified organizations & self-help portals',
          icon: Icons.language_rounded,
          color: const Color(0xFF0077B6),
          screen: WebsitesScreen(category: category),
        ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('$category Resources')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        itemCount: resourceTypes.length + 1, // +1 for header
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == 0) {
            // Header
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [categoryColor.withOpacity(0.15), categoryColor.withOpacity(0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: categoryColor.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.auto_awesome_rounded, color: categoryColor, size: 40),
                      const SizedBox(height: 12),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: categoryColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Explore curated resources to understand, manage and overcome',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
                      ),
                    ],
                  ),
                ).animate().fade().slideY(begin: -0.1),
                const SizedBox(height: 8),
              ],
            );
          }

          final rt = resourceTypes[index - 1];
          return _buildResourceCard(context, rt, index - 1);
        },
      ),
    );
  }

  Widget _buildResourceCard(BuildContext context, _ResourceType rt, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(color: rt.color.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => rt.screen));
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: rt.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(rt.icon, color: rt.color, size: 30),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rt.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF03045E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rt.subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade300),
            ],
          ),
        ),
      ),
    ).animate().fade(delay: (100 * index).ms).slideX(begin: 0.05, curve: Curves.easeOut);
  }
}

class _ResourceType {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;

  _ResourceType({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.screen,
  });
}