import 'package:flutter/material.dart';

class UniversityDetailScreen extends StatelessWidget {
  final Map<String, dynamic> university;

  UniversityDetailScreen({required this.university});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(university['universitie_title']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  university['universitie_content_image'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.white, size: 16),
                        SizedBox(width: 5),
                        Text(
                          "${university['universitie_study_time']} سال",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
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
                    university['universitie_title'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildJustifiedText(university['universitie_content']),
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
}
