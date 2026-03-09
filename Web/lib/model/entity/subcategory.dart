class Subcategory 
{
    String name;
    String description;
    String category;

    Subcategory({
        required this.name,
        required this.description,
        required this.category
    });

    factory Subcategory.fromJson(Map<String, dynamic> json) 
    {
        return Subcategory(
            name: json['name'] ?? '',
            description: json['description'] ?? '',
            category:  json['category'] ?? '',
        );
    }

    Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'category': category
    };
}