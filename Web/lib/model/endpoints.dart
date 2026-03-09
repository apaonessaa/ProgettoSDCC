class Endpoints 
{
    static const String HOST = String.fromEnvironment('HOST', defaultValue:'localhost:3000');
    static const String SERVICE = String.fromEnvironment('SERVICE', defaultValue:'localhost:8080');

    static String LOGIN = "http://$SERVICE/oauth2/sign_in?rd=http://$HOST/";
    static String LOGOUT = "http://$SERVICE/oauth2/sign_out";
    static String CHECK_ACCESS = "http://$SERVICE/oauth2/auth";
    static String USER_INFO = "http://$SERVICE/oauth2/userinfo";
    static String PUBLIC_API = "http://$SERVICE/public/api/";
    static String PROTECTED_API = "http://$SERVICE/api/";
    static String CLASSIFIER = "http://$SERVICE/ai/classifier";
    static String CORRECTOR = "http://$SERVICE/ai/corrector";
    static String SUMMARIZER = "http://$SERVICE/ai/summarizer";

    static const String ARTICLE = "articles";

    static String article(String title) {
        return "${ARTICLE}/${title}";
    }

    static String image(String title) {
        return "${article(title)}/image";
    }

    static const String CATEGORY = "categories";

    static String category(String category) {
        return "${CATEGORY}/${category}";
    } 

    static String subcategory(String category, String subcategory) {
        return "${CATEGORY}/${category}/subcategories/${subcategory}";
    }   

    static String category_articles(String category) {
        return "${CATEGORY}/${category}/articles";
    }

    static String subcategory_articles(String category, String subcategory) {
        return "${CATEGORY}/${category}/subcategories/${subcategory}/articles";
    }
}