class Category 
{
    String name;
    String description;
    List<String> subcategory=[];

    Category({
        required this.name,
        required this.description,
        required this.subcategory
    });

    factory Category.fromJson(Map<String, dynamic> json) 
    {
        return Category(
            name: json['name'] ?? '',
            description: json['description'] ?? '',
            subcategory: List<String>.from(json['subcategories'] ?? []),
        );
    }

    Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'subcategories': subcategory
    };
}