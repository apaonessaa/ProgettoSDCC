import 'package:newsweb/model/entity/article.dart';

class Sort {
  final bool empty;
  final bool sorted;
  final bool unsorted;

  Sort({required this.empty, required this.sorted, required this.unsorted});

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
      empty: json['empty'],
      sorted: json['sorted'],
      unsorted: json['unsorted'],
    );
  }
}

class Pageable {
  final int pageNumber;
  final int pageSize;
  final Sort sort;
  final int offset;
  final bool paged;
  final bool unpaged;

  Pageable({required this.pageNumber, required this.pageSize, required this.sort, required this.offset, required this.paged, required this.unpaged});

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      sort: Sort.fromJson(json['sort']),
      offset: json['offset'],
      paged: json['paged'],
      unpaged: json['unpaged'],
    );
  }
}


class PaginatedArticles {
  final int totalElements;
  final int totalPages;
  final int size;
  final List<Article> content;
  final int number;
  final Sort sort;
  final int numberOfElements;
  final Pageable pageable;
  final bool first;
  final bool last;
  final bool empty;

  PaginatedArticles({
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.content,
    required this.number,
    required this.sort,
    required this.numberOfElements,
    required this.pageable,
    required this.first,
    required this.last,
    required this.empty,
  });

  factory PaginatedArticles.fromJson(Map<String, dynamic> json) {
    var contentList = json['content'] as List;
    List<Article> articles = contentList.map((i) => Article.fromJson(i)).toList();

    return PaginatedArticles(
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      size: json['size'],
      content: articles,
      number: json['number'],
      sort: Sort.fromJson(json['sort']),
      numberOfElements: json['numberOfElements'],
      pageable: Pageable.fromJson(json['pageable']),
      first: json['first'],
      last: json['last'],
      empty: json['empty'],
    );
  }
}