import 'package:flutter/material.dart';
import '../models/category_model.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  PostDetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          post.title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  post.image,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Text(
                post.contentOne,
                style: TextStyle(fontSize: 18, height: 1.5, color: Colors.grey[800]),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16.0),
              Divider(height: 1, color: Colors.grey[300]),
              SizedBox(height: 16.0),
              Text(
                post.contentTwo,
                style: TextStyle(fontSize: 18, height: 1.5, color: Colors.grey[800]),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
