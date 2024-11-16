import 'package:flutter/material.dart';
import 'university_detail_screen.dart';

class AllUniversitiesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> universities;

  AllUniversitiesScreen({required this.universities});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('جميع الجامعات'),
      ),
      body: ListView.builder(
        itemCount: universities.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(universities[index]['universitie_image'], width: 50),
            title: Text(universities[index]['universitie_title']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UniversityDetailScreen(university: universities[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
