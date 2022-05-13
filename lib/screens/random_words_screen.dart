import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWordsScreen extends StatefulWidget {
  const RandomWordsScreen({super.key});

  @override
  State<RandomWordsScreen> createState() => _RandomWordsScreenState();
}

class _RandomWordsScreenState extends State<RandomWordsScreen> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            onPressed: _pushSaved,
            icon: const Icon(Icons.list),
            tooltip: 'Saved Suggestions',
          )
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            if (i.isOdd) {
              return const Divider();
            }

            final index = i ~/ 2;
            if (index >= _suggestions.length) {
              _suggestions.addAll(generateWordPairs().take(10));
            }
            final isAlreadySaved = _saved.contains(_suggestions[index]);

            return ListTile(
              title: Text(
                _suggestions[index].asPascalCase,
                style: _biggerFont,
              ),
              trailing: Icon(
                isAlreadySaved ? Icons.favorite : Icons.favorite_border,
                color: isAlreadySaved ? Colors.red : null,
                semanticLabel: isAlreadySaved ? 'Remove from saved' : 'Save',
              ),
              onTap: () {
                setState(() {
                  if (isAlreadySaved) {
                    _saved.remove(_suggestions[index]);
                    return;
                  }
                  _saved.add(_suggestions[index]);
                });
              },
            );
          }),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) {
        final tiles = _saved.map((pair) => ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            ));
        final divided = tiles.isNotEmpty
            ? ListTile.divideTiles(tiles: tiles, context: context).toList()
            : <Widget>[];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Saved Suggestions'),
          ),
          body: ListView(
            children: divided,
          ),
        );
      },
    ));
  }
}
