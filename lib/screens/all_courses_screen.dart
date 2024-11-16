import 'package:flutter/material.dart';
import 'course_detail_screen.dart';

class AllCoursesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> courses;

  AllCoursesScreen({required this.courses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('جميع الدورات'),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return ListTile(
            leading: Image.network(course['course_image']),
            title: Text(course['course_expertise']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailScreen(course: course),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
