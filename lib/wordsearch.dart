import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class WordsearchPage extends StatelessWidget {
  const WordsearchPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _WordsearchState createState() => _WordsearchState();

}

class _WordsearchState extends State<WordsearchPage> with SingleTickerProviderStateMixin {
  final List<String> _saved = <String>[];
  final List<String> _savedwords = <String>[];
  final List<String> _letters = <String>[];
  final List<bool> _userletters = <bool>[];
  final List<String> _words = ["horses", "python", "compsci"];
  final List<double> _dragX = <double>[];
  final List<double> _dragY = <double>[];
  //final List<int> _positions = <int>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 24);
  final TextStyle _bigFont = const TextStyle(fontSize: 18);

  final String correct_word = "horses";
  final int grid_size = 10;

  void setupgrid() {
    for (var i=0; i<grid_size*grid_size; i++) {
      _letters.add("1");
      _userletters.add(false);
    }
    int pos = 0;
    for (var w in _words) {
      for (var l=0; l<w.length; l++) {
        _letters[pos] = w[l];
        pos++;
      }
      while (pos % grid_size != 0) {
        pos++;
      }
    }

    for (var i=0; i<grid_size*grid_size; i++) {
      if (_letters[i] == "1") {
        _letters[i] = randLetters(1);
      }
    }
  }

  String randLetters(int n) {
    const _chars = 'abcdefghijklmnopqrstuvwxyz';
    Random _rnd = Random();

    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    return getRandomString(n);
  }

  void checkisright() {
    var p = "";
    bool found_correct = false;
    bool done = false;

    for (var i=0; i<_saved.length; i++) {
      p = p + _saved[i];
    }

    if (correct_word == p) {
      found_correct = true;
    }

    showMessage(p, found_correct);
    _saved.clear();
  }

  void showMessage(String input, bool isfound) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Your answer: $input"),
              content: isfound
                  ? new Text(
                  "Codeword entered correctly")
                  : new Text("Incorrect"),
            actions: <Widget>[
              new TextButton(onPressed: () {Navigator.of(context).pop();}, child: new Text("close")),
            ],


          );
        },
    );
  }

  void clear() {
    setState(() {
      _savedwords.clear();
    });
    Navigator.of(context).pop();
  }

  @override
  void initState(){

  }
  @override
  void dispose() {
    super.dispose();
  }


}