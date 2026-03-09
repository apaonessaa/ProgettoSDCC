import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/view/layout/image_viewer.dart';
import 'package:newsweb/view/layout/quill_text_display.dart';

///  Display Article like this:
///  -----------------
///  |               |
///  |   image       |
///  |               |
///  ---------------- 
///  Title
///  ----------------
///  Summary
///  ----------------

class OneArticle extends StatelessWidget {
  final Article? article;
  final double width;
  final double height;
  final double imageCover;
  final bool withSummary;

  const OneArticle({
    this.article,
    this.width = double.maxFinite,
    this.height = 300,
    this.imageCover = 0.60,
    this.withSummary = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (article == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: height,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        margin: const EdgeInsets.all(5),
        color: Theme.of(context).colorScheme.secondary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: InkWell(
          onTap: () {
            context.go('/article/${article!.title}');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * imageCover,
                width: double.infinity,
                child: ImageViewer(title: article!.title),
              ),

              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article!.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    if (withSummary) ...[
                      const SizedBox(height: 8),
                      QuillTextDisplay(text: article!.summary),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
