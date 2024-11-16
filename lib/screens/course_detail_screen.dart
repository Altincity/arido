import 'package:flutter/material.dart';

class CourseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> course;

  CourseDetailScreen({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course['course_expertise']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  course['course_image'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      course['course_experience_level'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['course_expertise'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildJustifiedText(course['course_content']),
                  SizedBox(height: 20),
                  _buildCourseDetails(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJustifiedText(String text) {
    List<TextSpan> spans = [];
    var words = text.split(' ');

    for (var word in words) {
      spans.add(TextSpan(text: word + ' ', style: TextStyle(fontSize: 16)));
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: TextStyle(color: Colors.black), // color for entire text
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildCourseDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: Colors.blue),
            SizedBox(width: 8),
            Text('مکان: ' + course['course_province']),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.school, color: Colors.green),
            SizedBox(width: 8),
            Text('نوع دانشگاه: ' + course['course_university_type']),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.flag, color: Colors.red),
            SizedBox(width: 8),
            Text('کشور: ' + course['course_nation']),
          ],
        ),
        SizedBox(height: 20),
        Text(
          'دانشگاه: ${course['course_university']['university_title']}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Image.network(
          course['course_university']['university_content_image'],
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 10),
        _buildJustifiedText(
          course['course_university']['university_content'],
        ),
      ],
    );
  }
}
