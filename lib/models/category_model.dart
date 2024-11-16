class Category {
  final int categoryId;
  final String categoryTitle;
  final List<Post> posts;
  final List<Category> subCategories;

  Category({
    required this.categoryId,
    required this.categoryTitle,
    required this.posts,
    required this.subCategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'],
      categoryTitle: json['category_title'],
      posts: (json['posts'] as List)
          .map((post) => Post.fromJson(post))
          .toList(),
      subCategories: (json['sub_categories'] as List)
          .map((subCategory) => Category.fromJson(subCategory))
          .toList(),
    );
  }
}

class Post {
  final int id;
  final String title;
  final String image;
  final String contentOne;
  final String contentTwo;

  static const String domain = "https://aridoiraq.com/media";

  Post({
    required this.id,
    required this.title,
    required String imagePath,
    required this.contentOne,
    required this.contentTwo,
  }) : image = '$domain/$imagePath';

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      imagePath: json['image'],
      contentOne: json['content_one'],
      contentTwo: json['content_two'],
    );
  }
}
