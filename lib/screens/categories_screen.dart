import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category_model.dart';
import 'post_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      List<Category> categories = await ApiService().fetchCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التصنيفات', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 1,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return _buildCategoryCard(category);
              },
            ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: ExpansionTile(
          leading: Icon(Icons.category, color: Colors.teal),
          title: Text(
            category.categoryTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(Icons.keyboard_arrow_down, color: Colors.teal),
          children: [
            if (category.subCategories.isEmpty && category.posts.isNotEmpty)
              ...category.posts.map((post) => ListTile(
                    leading: Icon(Icons.article, color: Colors.blueAccent),
                    title: Text(post.title),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailScreen(post: post),
                        ),
                      );
                    },
                  )),
            if (category.subCategories.isNotEmpty)
              ...category.subCategories.map((subCategory) => _buildCategoryCard(subCategory)),
          ],
        ),
      ),
    );
  }
}

