import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsweb/model/retrive_data.dart';
import 'package:newsweb/model/entity/category.dart';

class CatAndSubcatFooter extends StatefulWidget 
{
  const CatAndSubcatFooter({super.key});

  @override
  _CatAndSubcatFooter createState() => _CatAndSubcatFooter();
}

class _CatAndSubcatFooter extends State<CatAndSubcatFooter> 
{
  late List<Category> categories = [];

  Future<void> fetchCategories() async 
  {
    try {
      List<Category> fetchedCategories = await RetriveData.sharedInstance.getCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  @override
  void initState() 
  {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) 
  {
    List<Row> items = [];
    for (int i = 0; i < categories.length; i += 3) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < 3 && (i + j) < categories.length; j++) {
        rowChildren.add(
          Expanded(
            child: ListOfCategoryAndSubcategory(
              category: categories[i + j],
            ),
          ),
        );
      }
      items.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowChildren,
        ),
      );
    }

    return PreferredSize(
      preferredSize: Size.infinite,
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
              ...items
            ],
          ),
        ),
      ),
    );
  }
}

class ListOfCategoryAndSubcategory extends StatelessWidget 
{
  final Category category;

  const ListOfCategoryAndSubcategory({super.key, required this.category});

  @override
  Widget build(BuildContext context) 
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/category/${category.name}');
            },
            child: Text(
              category.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          category.subcategory.isEmpty
              ? Container()
              : Wrap(
                  direction: Axis.horizontal,
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: category.subcategory.map((subcat) {
                    return TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.go('/category/${category.name}/subcategory/${subcat}');
                      },
                      child: Text(
                        subcat,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                      ),
                    );
                  }).toList(),
                ),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }
}

