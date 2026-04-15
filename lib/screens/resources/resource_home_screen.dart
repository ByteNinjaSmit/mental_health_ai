import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/resource_service.dart';
import 'resource_detail_screen.dart';

class ResourceHomeScreen extends StatelessWidget {
  const ResourceHomeScreen({super.key});

  static const _iconMap = {
    'psychology': Icons.psychology_rounded,
    'self_improvement': Icons.self_improvement_rounded,
    'healing': Icons.healing_rounded,
    'autorenew': Icons.autorenew_rounded,
    'bolt': Icons.bolt_rounded,
    'swap_vert': Icons.swap_vert_rounded,
    'category': Icons.category_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final categories = ResourceDataService.categories;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.3,
        ),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final name = cat['name'] as String;
          final color = Color(cat['color'] as int);
          final iconKey = cat['icon'] as String;
          final icon = _iconMap[iconKey] ?? Icons.category_rounded;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ResourceDetailScreen(category: name, categoryColor: color),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 30),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fade(delay: (60 * index).ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack);
        },
      ),
    );
  }
}