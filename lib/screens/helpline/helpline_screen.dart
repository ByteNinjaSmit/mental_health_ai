import 'package:flutter/material.dart';
import '../../services/helpline_service.dart';
import 'helpline_detail_screen.dart';

class HelplineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final helplines = HelplineService.helplines;

    return Scaffold(
      appBar: AppBar(title: Text("Helpline Support")),
      body: ListView.builder(
        itemCount: helplines.length,
        itemBuilder: (context, index) {
          final item = helplines[index];

          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.support_agent, color: Colors.blue),
              title: Text(item.name),
              subtitle: Text(item.description),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HelplineDetailScreen(helpline: item),
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