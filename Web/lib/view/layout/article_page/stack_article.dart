import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/view/layout/image_viewer.dart';

///  Display Articles like this (withImage):
///  -----------------
///  |               |
///  |   image1      |
///  |               |
///  ---------------- 
///  title1
///  ---------------- 
///  image2 title2
///  ---------------- 
///  image3 title3
///  ----------------
/// ...
/// 
/// else:
///  -----------------
///  |               |
///  |   image1      |
///  |               |
///  ---------------- 
///  title1
///  ---------------- 
///  title2
///  ---------------- 
///  title3
///  ----------------

class StackOfArticles extends StatelessWidget 
{
  final List<Article>? articles;
  final bool withImage;
  final double width;
  final double height;
  final double imageCover; // double in (0.0 , 1.0)

  const StackOfArticles({
    this.articles,
    this.width = double.maxFinite,
    this.height = 300,
    this.imageCover = 0.2,
    this.withImage = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) 
  {
    if (articles == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: height,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0.0,
        margin: const EdgeInsets.all(5.0),
        color: Theme.of(context).colorScheme.secondary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...articles!.asMap().entries.map((entry) {
              int index = entry.key;
              Article article = entry.value;
              if (index == 0) {
                // For the first article, show image above the title
                return ListTile(
                  onTap: () {
                    context.go('/article/${article!.title}');
                  },
                  title: Padding(
                    padding: const EdgeInsets.only(
                      left: 0.5,
                      right: 0.5,
                      top: 0.5,
                      bottom: 10.0,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: height * imageCover,
                      child: ImageViewer(title: article.title)
                    ),                    
                  ),
                  subtitle: Text(
                    article.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              } else {
                // For other articles or when withImage is false
                return Column(
                  children: [
                    Divider(),
                    const SizedBox(height: 1.0),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      onTap: () {
                        context.go('/article/${article!.title}');
                      },
                      leading: withImage
                          ? SizedBox(
                              width: 75,
                              height: 75,
                              child: ImageViewer(title: article.title)
                            )
                          : null,
                      title: Text(
                        article.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                    const SizedBox(height: 1.0),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
