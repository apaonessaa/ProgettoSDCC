import 'dart:typed_data';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/model/entity/paging.dart';
import 'package:newsweb/model/entity/category.dart';
import 'package:newsweb/model/entity/subcategory.dart';
import 'package:newsweb/model/service.dart';
import 'package:newsweb/model/endpoints.dart';

class RetriveData 
{
    static RetriveData sharedInstance = RetriveData();

    Future<String> corrector(String text) async 
    {
        final body = { 'text': text, };

        try {
            dynamic response = await Service.request(
                HttpMethod.POST,
                Endpoints.CORRECTOR,
                '', 
                body: body,
                includeCredentials: true
            );

            if (response != null && response['result'] != null) {
                return response['result'];
            } else {
                throw Exception('Risultato non presente nella risposta');
            }
        } catch (error) {
            throw Exception('Errore nella richiesta di correzione: $error');
        }
    }

    Future<List<String>> classifier(String text, List<String> labels) async 
    {
        final body = { 'text': text, 'labels': labels };

        try {
            dynamic response = await Service.request(
                HttpMethod.POST,
                Endpoints.CLASSIFIER,
                '', 
                body: body,
                includeCredentials: true
            );

            if (response != null && response['result'] != null) {
                return response['result'];
            } else {
                throw Exception('Risultato non presente nella risposta');
            }
        } catch (error) {
            throw Exception('Errore nella richiesta di correzione: $error');
        }
    }

    Future<String> summarizer(String text) async 
    {
        final body = { 'text': text, };

        try {
            dynamic response = await Service.request(
                HttpMethod.POST,
                Endpoints.SUMMARIZER,
                '', 
                body: body,
                includeCredentials: true
            );

            if (response != null && response['result'] != null) {
                return response['result'];
            } else {
                throw Exception('Risultato non presente nella risposta');
            }
        } catch (error) {
            throw Exception('Errore nella richiesta di correzione: $error');
        }
    }

    Future<Subcategory> getSubcategory(String category, String subcategory) async 
    {
        try {
            dynamic response = await Service.request(
                HttpMethod.GET,
                Endpoints.PUBLIC_API,
                Endpoints.subcategory(category, subcategory)
            );
            return Subcategory.fromJson(response);
        } catch (error) {
            throw Exception();
        }
    }

    Future<Category> getCategory(String category) async 
    {
        try {
            dynamic response = await Service.request(
                HttpMethod.GET,
                Endpoints.PUBLIC_API,
                Endpoints.category(category)
            );
            return Category.fromJson(response);
        } catch (error) {
            throw Exception();
        }
    }

    Future<PaginatedArticles?> getArticleToUpdate(int pageNumber, int pageSize) async 
    {
        try {
            dynamic response = await Service.request(
              HttpMethod.GET,
              Endpoints.PUBLIC_API,
              Endpoints.ARTICLE,
              params: {
                  'pageNumber': '$pageNumber',
                  'pageSize': '$pageSize',
              },
            );
            if (response != null && response is Map<String, dynamic>) {
            print("API response: $response"); 
            return PaginatedArticles.fromJson(response);
            }
            return null;
        } catch (error) {
            print("Error fetching articles: $error");
            throw Exception('Error fetching articles');
        }
    }

    Future<PaginatedArticles?> getArticleByCategory(String cat, int pageNumber, int pageSize) async 
    {
        try {
            dynamic response = await Service.request(
            HttpMethod.GET,
            Endpoints.PUBLIC_API,
            Endpoints.category_articles(cat),
            params: {
                'pageNumber': '$pageNumber',
                'pageSize': '$pageSize',
            },
            );

            if (response != null && response is Map<String, dynamic>) {
            print("API response: $response"); 
            return PaginatedArticles.fromJson(response);
            }
            return null;
        } catch (error) {
            print("Error fetching articles: $error");
            throw Exception('Error fetching articles');
        }
    }

    Future<PaginatedArticles?> getArticleBySubcategory(String cat, String subcat, int pageNumber, int pageSize) async 
    {
        try {
            dynamic response = await Service.request(
            HttpMethod.GET,
            Endpoints.PUBLIC_API,
            Endpoints.subcategory_articles(cat,subcat),
            params: {
                'pageNumber': '$pageNumber',
                'pageSize': '$pageSize',
            },
            );

            if (response != null && response is Map<String, dynamic>) {
            print("API response: $response"); 
            return PaginatedArticles.fromJson(response);
            }
            return null;
        } catch (error) {
            print("Error fetching articles: $error");
            throw Exception('Error fetching articles');
        }
    }

    Future<PaginatedArticles?> getMainArticles(int pageNumber, int pageSize) async 
    {
        try {
            dynamic response = await Service.request(
            HttpMethod.GET,
            Endpoints.PUBLIC_API,
            Endpoints.ARTICLE,
            params: {
                'pageNumber': '$pageNumber',
                'pageSize': '$pageSize',
            },
            );

            if (response != null && response is Map<String, dynamic>) {
            print("API response: $response"); 
            return PaginatedArticles.fromJson(response);
            }
            return null;
        } catch (error) {
            print("Error fetching articles: $error");
            throw Exception('Error fetching articles');
        }
    }

    Future<Article> getArticle(String title) async 
    {
        try {
            dynamic response = await Service.request(
                HttpMethod.GET,
                Endpoints.PUBLIC_API,
                Endpoints.article(title)
            );
            return Article.fromJson(response);
        } catch (error) {
            throw Exception();
        }
    }

    Future<Uint8List> getImage(String title) async 
    {
        try {
            dynamic response = await Service.request(
                HttpMethod.GET,
                Endpoints.PUBLIC_API,
                type: TypeHeader.IMAGE,
                Endpoints.image(title)
            );
            return response;
        } catch (error) {
            throw Exception();
        }
    }

    Future<List<Category>> getCategories() async 
    {
        try {
            dynamic response = await Service.request(
                HttpMethod.GET,
                Endpoints.PUBLIC_API,
                Endpoints.CATEGORY
            );
            if (response == null) {
                return [];
            }

            List<Category> categories = [];
            for (var categoryJson in response) {
                categories.add(Category.fromJson(categoryJson));
            }
            return categories;
        } catch (error) {
            throw Exception();
        }
    }
}