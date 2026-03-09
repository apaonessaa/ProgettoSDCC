import 'dart:html' as html;
import 'dart:typed_data';
import 'package:newsweb/model/service.dart';
import 'package:newsweb/model/endpoints.dart';

class User 
{
    String email;
    String username;

    User({
        required this.email,
        required this.username,
    });

    factory User.fromJson(Map<String, dynamic> json) 
    {
        return User(
            email: json['email'] ?? '',
            username: json['preferredUsername'] ?? ''
        );
    }

    Map<String, dynamic> toJson() => {
        'email': email,
        'preferredUsername': username
    };
}

class AuthService 
{
    static AuthService sharedInstance = AuthService();

    Future<User?> getUserInfo() async 
    {
        try {
            dynamic response = await Service.request(
                HttpMethod.GET,
                Endpoints.USER_INFO,
                '',
                includeCredentials: true
            );
            return User.fromJson(response);
        } catch (error) {
            return null;
        }
        return null;
    }

    Future<bool> checkAccess() async 
    {
        try {
            dynamic response = await Service.request(
                HttpMethod.GET,
                Endpoints.CHECK_ACCESS,
                '',
                includeCredentials: true
            );
            return true;
        } catch (error) {
            return false;
        }
        return false;
    }

    Future<void> logout() async 
    {
        html.window.location.href = Endpoints.LOGOUT;
    }

    Future<void> login() async 
    {
        html.window.location.href = Endpoints.LOGIN;
    }
}