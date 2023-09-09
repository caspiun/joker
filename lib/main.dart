import 'package:flutter/material.dart';
import 'package:test_app/data/NetworkServiceImpl.dart';
import 'package:test_app/data/RandomJokeRepositoryImpl.dart';
import 'package:test_app/domain/CategoriesRepositoryImpl.dart';
import 'package:test_app/domain/NetworkService.dart';
import 'package:test_app/domain/RandomJokeRepository.dart';
import 'package:test_app/screens/home/MyHomePage.dart';

void main() {
  NetworkService networkService = NetworkServiceImpl();
  RandomJokeRepository service = RandomJokeRepositoryImpl(networkService);
  JokeCategoriesRepository jokeCategoriesRepository =
  CategoriesRepositoryImpl(networkService);

  runApp(MyApp(service, jokeCategoriesRepository));
}

class MyApp extends StatelessWidget {
  final RandomJokeRepository service;
  final JokeCategoriesRepository jokeCategoriesRepository;

  const MyApp(this.service, this.jokeCategoriesRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: createCustomBlack(),
      ),
      home: HomeScreenWithBloc(service, jokeCategoriesRepository),
    );
  }

  MaterialColor createCustomBlack() {
    return MaterialColor(
      0xFF000000, // Change this to the desired black color code
      <int, Color>{
        50: Color(0xFFE0E0E0),
        100: Color(0xFFB3B3B3),
        200: Color(0xFF808080),
        300: Color(0xFF4D4D4D),
        400: Color(0xFF262626),
        500: Color(0xFF000000), // Primary black
        600: Color(0xFF000000),
        700: Color(0xFF000000),
        800: Color(0xFF000000),
        900: Color(0xFF000000),
      },
    );
  }
}
