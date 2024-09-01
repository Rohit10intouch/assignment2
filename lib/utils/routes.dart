import 'package:assignment2/screen/news_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screen/home_screen.dart';

class SlidePageRoute extends PageRouteBuilder {
  final WidgetBuilder builder;
  final RouteSettings settings;

  SlidePageRoute({required this.builder, RouteSettings? settings})
      : settings = settings ?? const RouteSettings(),
        super(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final begin = const Offset(1.0, 0.0);
          final end = Offset.zero;
          final curve = Curves.easeInOut;
          final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
}

class Routes {
  static const String homeScreen = '/homeScreen';
  static const String newsScreen = '/newsScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return SlidePageRoute(
          builder: (context) => const HomeScreen(),
        );

      case newsScreen:
      // Ensure settings.arguments is not null and is of the correct type
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return SlidePageRoute(
            builder: (context) => NewsDetailScreen(
              title: args['title'],
              description: args['description'],
              imageUrl: args['imageUrl'],
              publishedDate: args['publishedDate'],
              isFavorite: args['isFavorite'],
              onToggleFavorite: args['onToggleFavorite'],
            ),
          );
        } else {
          return _errorRoute();
        }
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return SlidePageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text('Route Not Available'),
        ),
      ),
    );
  }
}