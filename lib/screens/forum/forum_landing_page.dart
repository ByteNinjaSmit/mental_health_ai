import 'package:flutter/material.dart';
import '../topics_page.dart';

class ForumLandingPage extends StatelessWidget {
  final List<String> categories = [
    'Anxiety',
    'Depression',
    'PTSD',
    'OCD',
    'Stress',
    'Bipolar',
    'Miscellaneous'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Community Forum")),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(categories[index]),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TopicsPage(category: categories[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}