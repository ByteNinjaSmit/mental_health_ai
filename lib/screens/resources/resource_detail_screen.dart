import 'package:flutter/material.dart';
import '../../services/resource_service.dart';
import 'youtube_screen.dart';
import 'pdf_viewer_screen.dart';

class ResourceDetailScreen extends StatelessWidget {
  final String category;

  ResourceDetailScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    final resources = ResourceService.data[category] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: ListView.builder(
        itemCount: resources.length,
        itemBuilder: (context, index) {
          var item = resources[index];

          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(item['title']!),
              subtitle: Text(item['type']!),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                if (item['type'] == 'video') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => YoutubeScreen(
                        url: item['content']!,
                      ),
                    ),
                  );
                } else if (item['type'] == 'pdf') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PdfViewerScreen(
                        url: item['content']!,
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(item['title']!),
                      content: Text(item['content']!),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}