import 'package:flutter/material.dart';
//import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:newsweb/view/theme/theme.dart';
import 'package:newsweb/view/theme/text_theme.dart';
import 'package:newsweb/view/layout/util.dart';
import 'package:newsweb/view/main_page.dart';
import 'package:newsweb/view/article_page.dart';
import 'package:newsweb/view/category_page.dart';
import 'package:newsweb/view/subcategory_page.dart';
import 'package:newsweb/view/admin_page.dart';
import 'package:newsweb/view/form/article_form_page.dart';
import 'package:newsweb/view/form/article_update_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  //setUrlStrategy(PathUrlStrategy());
  runApp(App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _App();
}

class _App extends State<App> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Atkinson Hyperlegible", "Atkinson Hyperlegible");
    MaterialTheme theme = MaterialTheme(textTheme);
    
    final GoRouter router = GoRouter(
      navigatorKey: NavigationService.navigatorKey,
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const MainPage();
          },
          routes: <RouteBase>[
            GoRoute(
              path: '/article/:title',
              builder: (BuildContext context, GoRouterState state) {
                final title = state.pathParameters['title']!;
                return ArticlePage(title: title);
              },
            ),
            GoRoute(
              path: '/category/:name',
              builder: (BuildContext context, GoRouterState state) {
                final name = state.pathParameters['name']!;
                return CategoryPage(categoryName: name);
              },
            ),
            GoRoute(
              path: '/category/:cname/subcategory/:scname',
              builder: (BuildContext context, GoRouterState state) {
                final category = state.pathParameters['cname']!;
                final subcategory = state.pathParameters['scname']!;
                return SubcategoryPage(categoryName: category, subcategoryName: subcategory);
              },
            ),
            GoRoute(
              path: '/admin',
              builder: (BuildContext context, GoRouterState state) {
                return AdminPage();
              },
            ),
            GoRoute(
              path: '/admin/article',
              builder: (BuildContext context, GoRouterState state) {
                return ArticleFormPage();
              },
            ),
            GoRoute(
              path: '/admin/article/:title',
              builder: (BuildContext context, GoRouterState state) {
                final title = state.pathParameters['title']!;
                return ArticleUpdatePage(title: title);
              },
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
        ),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: const Color.fromARGB(255, 136, 136, 136),
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: Colors.white,
          onSecondary: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
          ),
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        quill.FlutterQuillLocalizations.delegate, 
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('it', ''), 
      ],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.1)),
          child: child!,
        );
      },
    );
  }
}
