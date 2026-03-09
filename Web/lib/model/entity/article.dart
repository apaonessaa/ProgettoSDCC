class Article 
{
    String title;
    String summary;
    String content;
    String category;
    List<String> subcategory;
    String image;
      
    Article({
        required this.title,
        required this.summary,
        required this.content,
        required this.category,
        required this.subcategory,
        required this.image
    });

    factory Article.fromJson(Map<String, dynamic> json) 
    {
        return Article(
            title: json['title'] ?? '',
            summary: json['summary'] ?? '',
            content: json['content'] ?? '',
            category: json['category'] ?? '',
            subcategory: List<String>.from(json['subcategories'] ?? []),
            image: json['image']
        );
    }

    Map<String, dynamic> toJson() => {
        'title': title,
        'summary': summary,
        'content': content,
        'category': category,
        'subcategories': subcategory,
        'image': image
    };
}