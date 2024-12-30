class Book {
  final String id;
  String title;
  String author;
  String cover;
  String summary;
  List<int> ratings; // Non-nullable list

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.cover,
    required this.summary,
    List<int>? ratings, // Parameter can be nullable
  }) : ratings = ratings ?? []; // But we ensure non-null with default value

  double get averageRating {
    if (ratings.isEmpty) return 0.0;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }
}
