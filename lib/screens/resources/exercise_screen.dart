import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../services/resource_service.dart';
import 'youtube_screen.dart';

class ExerciseScreen extends StatelessWidget {
  final String category;

  const ExerciseScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final data = ResourceDataService.exercises[category];
    final videos = data?['videos'] ?? [];
    final articles = data?['articles'] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('$category Exercises')),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // ── Video Exercises Section ──
          _SectionHeader(
            title: 'Video Exercises',
            icon: Icons.play_circle_filled_rounded,
            color: const Color(0xFFEF5350),
          ).animate().fade().slideX(begin: -0.05),
          const SizedBox(height: 10),
          ...videos.asMap().entries.map((entry) {
            final index = entry.key;
            final video = entry.value;
            return _VideoExerciseCard(video: video, index: index);
          }),

          const SizedBox(height: 28),

          // ── Articles Section ──
          _SectionHeader(
            title: 'Exercise Articles',
            icon: Icons.article_rounded,
            color: const Color(0xFF5C6BC0),
          ).animate().fade().slideX(begin: -0.05),
          const SizedBox(height: 10),
          ...articles.asMap().entries.map((entry) {
            final index = entry.key;
            final article = entry.value;
            return _ArticleCard(article: article, index: index);
          }),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _VideoExerciseCard extends StatelessWidget {
  final Map<String, String> video;
  final int index;

  const _VideoExerciseCard({required this.video, required this.index});

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayer.convertUrlToId(video['url'] ?? '');
    final thumbnailUrl = videoId != null
        ? 'https://img.youtube.com/vi/$videoId/mqdefault.jpg'
        : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: InkWell(
          onTap: () {
            if (video['url'] != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => YoutubeScreen(url: video['url']!),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 100,
                    height: 70,
                    child: thumbnailUrl.isNotEmpty
                        ? Image.network(
                            thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.play_circle_outline, color: Colors.grey),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.play_circle_outline, color: Colors.grey),
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video['title'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF03045E),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tap to watch',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.play_circle_fill_rounded, color: Color(0xFFEF5350), size: 32),
              ],
            ),
          ),
        ),
      ),
    ).animate().fade(delay: (80 * index).ms).slideX(begin: 0.05);
  }
}

class _ArticleCard extends StatelessWidget {
  final Map<String, String> article;
  final int index;

  const _ArticleCard({required this.article, required this.index});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF5C6BC0).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.article_rounded, color: Color(0xFF5C6BC0), size: 22),
          ),
          title: Text(
            article['title'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF03045E)),
          ),
          subtitle: Text(
            'Tap to read article',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
          trailing: Icon(Icons.open_in_new_rounded, color: Colors.grey.shade400, size: 18),
          onTap: () => _launchUrl(article['url'] ?? ''),
        ),
      ),
    ).animate().fade(delay: (80 * index).ms).slideX(begin: 0.05);
  }
}
