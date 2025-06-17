import 'dart:ffi';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'dexalpha',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(113, 68, 137, 255)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var a = 1;

  void getNext() {
    a ++;
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var paire = appState.current;

    IconData icon;
    if (appState.favorites.contains(paire)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(paire: paire),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: (){
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like')
                ),
                SizedBox(width: 10),
                ButtonChangeBg(appState: appState),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ButtonChangeBg extends StatelessWidget {
  const ButtonChangeBg({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(appState.a % 255, (appState.a * 2) % 255, (appState.a * 3) % 255, 155), // Primary color
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      onPressed: (){
        appState.getNext();
        print("button pressed");
      },
      child: Text('Next ${appState.a.toString()}'),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.paire,
  });

  final WordPair paire;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary
    );

    return Card(
      elevation: 5,
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          paire.asCamelCase,
          style: style,
          semanticsLabel: "${paire.first} ${paire.second}",
        ),
      ),
    );
  }
}
