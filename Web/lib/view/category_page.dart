import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsweb/model/retrive_data.dart';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/model/entity/category.dart';
import 'package:newsweb/view/layout/custom_page.dart';
import 'package:newsweb/view/layout/article_page/layer.dart';
import 'package:newsweb/view/layout/article_page/list_article.dart';
import 'package:newsweb/view/layout/article_page/one_article.dart';
import 'package:newsweb/view/layout/article_page/stack_article.dart';
import 'package:newsweb/view/layout/cat_subcat_footer.dart';
import 'package:newsweb/view/layout/util.dart';

class CategoryPage extends StatefulWidget 
{
  final String categoryName;

  const CategoryPage({super.key, required this.categoryName});

  @override
  _CategoryPage createState() => _CategoryPage();
}

class _CategoryPage extends State<CategoryPage> 
{
  late Category category;
  bool isLoadingCategory = true;
  bool hasErrorCategory = false;

  late List<Article> articles;
  bool isLoading = true;
  bool hasError = false;

  int pageNumber = 0;
  int pageSize = 10;
  int maxPageNumber = 0;

  @override
  void initState() {
    super.initState();
    articles = [];
    _loadCategory();
    _loadArticles();
  }


  @override
  void dispose() {
    articles.clear();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      isLoading = true;
      isLoadingCategory = true;
      articles = [];
    });
    articles = [];
    _loadCategory();
    _loadArticles();
  }

  Future<void> _loadCategory() async 
  {
    try {
      final result = await RetriveData.sharedInstance.getCategory(widget.categoryName);
      setState(() {
        if (result != null) {
          category = result;
        }
        isLoadingCategory = false;
      });
    } catch (error) {
      setState(() {
        isLoadingCategory = false;
        hasErrorCategory = true;
      });
    }
  }

  Future<void> _loadArticles() async 
  {
    try {
      final result = await RetriveData.sharedInstance.getArticleByCategory(
          widget.categoryName, pageNumber, pageSize);
      setState(() {
        if (result != null) {
          articles = result.content;
          maxPageNumber = result.totalPages;
        }
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  void _nextPage() {
    if (pageNumber < maxPageNumber - 1) {
      setState(() {
        pageNumber++;
        isLoading = true;
      });
      _loadArticles();
    }
  }

  void _previousPage() {
    if (pageNumber > 0) {
      setState(() {
        pageNumber--;
        isLoading = true;
      });
      _loadArticles();
    }
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = UtilsLayout.setWidth(context);

    List<Widget> actions = [
      Util.btn(
        Icons.home,
        'Home',
        () {
          context.go('/');
        },
      ),
    ];

    if (isLoadingCategory) {
      return CustomPage(
        actions: actions,
        content: [Util.isLoading()],
      );
    }

    if (hasErrorCategory) {
      return CustomPage(
        actions: actions,
        content: [
          UtilsLayout.layout(
            [Util.error("Errore nel caricamento della categoria.")],
            maxWidth,
          ),
          const SizedBox(height: 100),
          const SizedBox.shrink(),
          const CatAndSubcatFooter(),
        ],
      );
    }

    return CustomPage(
      actions: actions,
      content: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UtilsLayout.layout(_build(context), maxWidth),
          ]
        ),
        const SizedBox(height: 100),
        const SizedBox.shrink(),
        const CatAndSubcatFooter(),
      ],
    );
  }

  List<Widget> _build(BuildContext context) 
  {
    if (isLoading) {
      return [ Util.isLoading() ];
    }

    if (hasError) {
      return [ Util.error("Errore nel caricamento dell'articolo.") ];
    }

    List<Article> page = List<Article>.from(articles);

    if (page.isEmpty) {
      return [const Text("Nessun articolo disponibile.")];
    }

    return [
        const SizedBox(height: 40.0),

        Text(
          category.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),

        const SizedBox(height: 20.0),

        Text(
          category.description,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.start,
        ),

        const SizedBox(height: 40.0),

        // LAYER
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// LEFT STACK
            if (page.isNotEmpty)
              Expanded(
                child: StackOfArticles(
                  articles: Util.getAndRemove<Article>(page, 4),
                  withImage: true,
                  height: 500,
                  imageCover: 0.40,
                ),
              ),

            /// RIGHT LIST
            if (page.isNotEmpty)
              Expanded(
                child: ListOfArticles(
                  articles: Util.getAndRemove<Article>(page, 6),
                  withImage: true,
                  height: 500,
                ),
              ),
          ],
        ),
        
        // Paginazione
        const SizedBox(height: 20.0),
        const Spacer(flex: 1),
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                IconButton(
                    icon: const Icon(Icons.arrow_circle_left, color: Colors.red),
                    onPressed: () {
                        // update page number and full state
                        if(pageNumber>0) {
                            pageNumber-=1;
                            _previousPage();
                        }
                    },
                ),
                IconButton(
                    icon: const Icon(Icons.arrow_circle_right, color: Colors.red),
                    onPressed: () {
                        // update page number and full state
                        if (pageNumber+1<maxPageNumber) {
                            pageNumber+=1;
                            _nextPage();
                        }
                    },
                ),
            ],
        ),

        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Text(
                    '${maxPageNumber!=0 ? pageNumber+1 : pageNumber}/$maxPageNumber', 
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary, 
                        fontSize: 12.0, 
                        fontWeight: FontWeight.normal),
                ),
            ],
        ),
    ];
  }
}
