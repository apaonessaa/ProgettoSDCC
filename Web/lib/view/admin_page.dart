import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:newsweb/model/auth_service.dart';
import 'package:newsweb/model/retrive_data.dart';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/view/layout/custom_page.dart';
import 'package:newsweb/view/layout/article_page/layer.dart';
import 'package:newsweb/view/layout/image_viewer.dart';
import 'package:newsweb/view/layout/util.dart';

class AdminPage extends StatefulWidget 
{ 
    const AdminPage({super.key}); 
    @override _AdminPage createState() => _AdminPage(); 
}

class _AdminPage extends State<AdminPage> 
{
    User? user;
    bool isLoadingUser = true;
    bool hasErrorUser = false;

    late List<Article> articles;
    bool isLoading = true;
    bool hasError = false;

    int pageNumber = 0;
    int pageSize = 6;
    int maxPageNumber = 0;

    bool loggedIn=false;

    @override
    void initState() 
    {
        super.initState();
        checkAccess();
        _loadUser();
        articles = [];
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
            loggedIn=false;
            isLoading = true;
            isLoadingUser = true;
            articles = [];
        });
        checkAccess();
        _loadUser();
        _loadArticles();
    }

    Future<void> checkAccess() async {
        final result = await AuthService.sharedInstance.checkAccess();
        if (mounted) {
            setState(() {
                loggedIn = result;
            });
        }
    }

    Future<void> _loadUser() async 
    {
        try {
            final result = await AuthService.sharedInstance.getUserInfo();
            setState(() {
                if (result != null) {
                    user = result;
                }
                isLoadingUser = false;
            });
            } catch (error) {
                setState(() {
                isLoadingUser = false;
                hasErrorUser = true;
            });
        }
    }

    Future<void> _loadArticles() async 
    {
        try {
            final result = await RetriveData.sharedInstance.getArticleToUpdate(pageNumber, pageSize);
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

    void _nextPage() 
    {
        if (pageNumber < maxPageNumber - 1) {
            setState(() {
                pageNumber++;
                isLoading = true;
            });
            _loadArticles();
        }
    }

    void _previousPage() 
    {
        if (pageNumber > 0) {
            setState(() {
                pageNumber--;
                isLoading = true;
                });
            _loadArticles();
        }
    }

    @override
    Widget build(BuildContext context) 
    {
        if (!loggedIn) {
            return Util.error("Errore con il caricamento del profilo.");
        }

        if(isLoadingUser)
            return Util.isLoading();
        if (hasError)
            return Util.error("Errore con il caricamento del profilo.");

        double maxWidth = UtilsLayout.setWidth(context);
    
        return CustomPage(
            actions: [
                Util.btn(
                    Icons.home,
                    'Home',
                    () {
                        Navigator.of(context).pop();
                        context.go('/');
                    }
                ),
                Util.btn(
                    Icons.logout,
                    'Logout',
                    () async {
                        await AuthService.sharedInstance.logout();
                    },
                ),
            ],
            content: [
                const SizedBox(height: 40.0),
                Center(
                  child: Text(
                    "Bentornato ${user!.username}!",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                      ),
                ),
                const SizedBox(width: 16), 
                UtilsLayout.layout(_build(context), maxWidth),
                const SizedBox(height: 100),
                const SizedBox.shrink(),
            ],
        );
    }

    List<Widget> _build(BuildContext context) {

      List<Article> page = List<Article>.from(articles);

      return [
        const SizedBox(height: 30),

        Center(
          child: SizedBox(
            width: 160,
            height: 40,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Nuovo articolo"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
              ),
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/admin/article');
              },
            ),
          ),
        ),

        const SizedBox(height: 40),

        if (isLoading)
          Util.isLoading(),

        if (hasError)
          Util.error("Errore nel caricamento degli articoli."),

        if (!isLoading && page.isEmpty)
          const Center(child: Text("Nessun articolo disponibile")),

        if (page.isNotEmpty)
          ListOfArticlesToModify(
            articles: Util.getAndRemove<Article>(page, 6),
          ),

        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              iconSize: 36,
              icon: const Icon(Icons.arrow_circle_left, color: Colors.red),
              onPressed: pageNumber > 0 ? _previousPage : null,
            ),

            const SizedBox(width: 10),

            Text(
              '${maxPageNumber != 0 ? pageNumber + 1 : pageNumber}/$maxPageNumber',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(width: 10),

            IconButton(
              iconSize: 36,
              icon: const Icon(Icons.arrow_circle_right, color: Colors.red),
              onPressed: pageNumber + 1 < maxPageNumber ? _nextPage : null,
            ),
          ],
        ),

        const SizedBox(height: 60),
      ];
    }
}

class ListOfArticlesToModify extends StatelessWidget 
{
  final List<Article>? articles;
  final double? width;
  final double? height;

  const ListOfArticlesToModify({
    super.key,
    this.articles,
    this.width = double.maxFinite,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          for (int index = 0; index < articles!.length; index++)
            Column(
              children: [
                if (index > 0) const Divider(height: 1),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go('/admin/article/${articles![index].title}');
                  },
                  leading: SizedBox(
                    width: 80,
                    height: 80,
                    child: ImageViewer(title: articles![index].title),
                  ),
                  title: Text(
                    articles![index].title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
