import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/domain/RandomJokeRepository.dart';
import 'package:test_app/model/RandomJokeResponse.dart';
import 'package:test_app/screens/home/HomeBloc.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreenWithBloc extends StatefulWidget {
  final RandomJokeRepository _service;
  final JokeCategoriesRepository _jokeCategoriesRepository;

  HomeScreenWithBloc(this._service, this._jokeCategoriesRepository, {Key? key})
      : super(key: key);

  @override
  State<HomeScreenWithBloc> createState() => _HomeScreenWithBlocState();
}

class _HomeScreenWithBlocState extends State<HomeScreenWithBloc> {
  final player = AudioPlayer();
  final textController = TextEditingController();
  List<String> customJokes = [];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RandomJokesBloc(widget._service)),
        BlocProvider(
            create: (context) =>
                CategoriesBloc(widget._jokeCategoriesRepository))
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text(
            "Random Joke App",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'Enter your custom joke',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add entered text to the customJokes list
                  customJokes.add(textController.text);
                  // Clear the text field
                  textController.clear();
                  setState(() {});
                },
                child: Text('Add Custom Joke'),
              ),
              SizedBox(height: 30),
              Text('Custom Jokes',style: TextStyle(color: Colors.teal,fontSize: 40,fontWeight: FontWeight.w700),),
              customJokesList(), // Display the custom jokes
              SizedBox(height: 30),
              Text('Random Jokes',style: TextStyle(color: Colors.teal,fontSize: 40,fontWeight: FontWeight.w700),),
              SizedBox(height: 20),
              tabsConsumer(),
              randomJokeConsumer(),
            ],
          ),
        ),
        floatingActionButton: loadRandomJokeButton(context),
        bottomNavigationBar: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FloatingActionButton(
                onPressed: () {
                  player.play(AssetSource('note1.wav'));
                },
                child: Icon(Icons.music_note),
              ),
              SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                onPressed: () {
                  player.stop();
                },
                child: Icon(Icons.stop),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadRandomJokeButton(BuildContext context) {
    return BlocConsumer<RandomJokesBloc, RandomJokeState>(
        listener: (context, state) {},
        builder: (context, state) => FloatingActionButton(
          onPressed: () {
            context.read<CategoriesBloc>().add(LoadCategories());
            context.read<RandomJokesBloc>().add(LoadRandomJoke());
          },
          child: state.isLoading
              ? const CircularProgressIndicator()
              : const Icon(Icons.file_download),
        ));
  }

  Widget customJokesList() {
    return Column(
      children: customJokes.map((text) => Text(text)).toList(),
    );
  }

  BlocConsumer<RandomJokesBloc, RandomJokeState> randomJokeConsumer() {
    return BlocConsumer<RandomJokesBloc, RandomJokeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Text(state.randomJoke).withPadding(const EdgeInsets.all(8));
      },
    );
  }

  BlocConsumer<CategoriesBloc, CategoriesState> tabsConsumer() {
    return BlocConsumer(
        builder: (context, state) {
          return ListView(
            scrollDirection: Axis.horizontal,
            children: state.jokeCategories
                .map((e) => Tab(
              child: TextButton(
                child: Text(e),
                onPressed: () {
                  context
                      .read<RandomJokesBloc>()
                      .add(LoadRandomJoke(e));
                },
              ),
            ))
                .toList(),
          ).height(56);
        },
        listener: (context, state) {});
  }
}

extension UiExtension on Widget {
  Widget withPadding(EdgeInsets edgeInsets) {
    return Padding(padding: edgeInsets, child: this);
  }

  Widget height(double value) {
    return SizedBox(
      height: value,
      width: double.infinity,
      child: this,
    );
  }
}
