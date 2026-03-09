import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsweb/model/retrive_data.dart';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/view/layout/custom_page.dart';
import 'package:newsweb/view/layout/article_page/layer.dart';
import 'package:newsweb/view/layout/article_page/list_article.dart';
import 'package:newsweb/view/layout/article_page/one_article.dart';
import 'package:newsweb/view/layout/article_page/stack_article.dart';
import 'package:newsweb/view/layout/cat_subcat_footer.dart';
import 'package:newsweb/view/layout/util.dart';
import 'package:newsweb/model/auth_service.dart';

class MainPage extends StatefulWidget 
{ 
    const MainPage({super.key}); 
    @override _MainPage createState() => _MainPage(); 
}

class _MainPage extends State<MainPage> 
{  
  late List<Article> articles;
  bool isLoading = true;
  bool hasError = false;
  List<Article> page = [];
  int pageNumber = 0;
  int pageSize = 16;
  int maxPageNumber = 0;
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();
    articles = [];
    _loadArticles();
    checkAccess();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      loggedIn=false;
      isLoading = true;
      articles = [];
    });
    _loadArticles();
    checkAccess();
  }

  @override
  void dispose() {
    articles.clear();
    super.dispose();
  }

  Future<void> checkAccess() async {
    final result = await AuthService.sharedInstance.checkAccess();
    if (mounted) {
      setState(() {
        loggedIn = result;
      });
    }
  }

  Future<void> _loadArticles() async 
  {
    try {
      final result = await RetriveData.sharedInstance.getMainArticles(pageNumber, pageSize);
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

  @override
  Widget build(BuildContext context) {
    double maxWidth = UtilsLayout.setWidth(context);
    List<Widget> actions = [
      if (loggedIn)
        Util.btn(
          Icons.account_circle,
          'Admin',
          () {
            Navigator.of(context).pop();
            context.go('/admin');
          },
        )
      else
        Util.btn(
          Icons.logout,
            'Login',
            () async {
              await AuthService.sharedInstance.login();
          },
        ),
    ];
    if (isLoading) {
      return CustomPage(
        actions: actions,
        content: [Util.isLoading()],
      );
    }

    if (hasError) {
      return CustomPage(
        actions: actions,
        content: [
          UtilsLayout.layout(
            [ Util.error("Errore nel caricamento dell'articolo.") ], 
            maxWidth
          ),
          const SizedBox(height: 100),
          const SizedBox.shrink(),
          const CatAndSubcatFooter(),
        ]
      );
    }

    return CustomPage(
      actions: actions,
      content: [
        UtilsLayout.layout(_build(context), maxWidth),
        const SizedBox(height: 100),
        const SizedBox.shrink(),
        const CatAndSubcatFooter()
      ],
    );
  }

  List<Widget> _build(BuildContext context) {
    if (articles.isEmpty) {
      return [const Text("Nessun articolo disponibile.")];
    }

    final page = List<Article>.from(articles);

    return [
      const SizedBox(height: 40),

      /// HERO SECTION
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HERO ARTICLE
          Expanded(
            flex: 2,
            child: OneArticle(
              article: page.removeAt(0),
              height: 520,
              imageCover: 0.70,
              withSummary: true,
            ),
          ),

          /// RIGHT STACK
          if (page.isNotEmpty)
            Expanded(
              child: StackOfArticles(
                articles: Util.getAndRemove<Article>(page, 4),
                withImage: true,
                height: 520,
                imageCover: 0.40,
              ),
            ),
        ],
      ),

      const SizedBox(height: 40),

      /// SECOND SECTION
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// LEFT STACK
          if (page.isNotEmpty)
            Expanded(
              child: StackOfArticles(
                articles: Util.getAndRemove<Article>(page, 4),
                withImage: true,
                height: 515,
                imageCover: 0.40,
              ),
            ),

          /// RIGHT LIST
          if (page.isNotEmpty)
            Expanded(
              child: ListOfArticles(
                articles: Util.getAndRemove<Article>(page, 7),
                withImage: true,
                height: 515,
              ),
            ),
        ],
      ),

      const SizedBox(height: 40),
    ];
  }
}
