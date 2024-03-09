import 'package:flutter/material.dart';
import 'package:wordsearch2fa/main.dart';
import 'dart:math';

import 'genws.dart';


const int gridSize = 10;

class WordsearchPage extends StatefulWidget {

  const WordsearchPage({super.key, required this.title, required this.pword});
  final String title;
  final String pword;

  @override
  WordsearchState createState() => WordsearchState();

}

class WordsearchState extends State<WordsearchPage> with SingleTickerProviderStateMixin {
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

  void setupgrid(List<String> words) {
    _words.add(widget.pword);
    _letters.addAll(generateWordsearch(words, gridSize));
    _userletters.addAll(List.filled(_letters.length, false));
  }

  void checkisright() {
    var p = "";
    bool foundCorrect = false;

    for (var i=0; i<_saved.length; i++) {
      p = p + _saved[i];
    }

    if (widget.pword == p) {
      foundCorrect = true;
    }

    showMessage(p, foundCorrect);
    _saved.clear();
  }

  void showMessage(String input, bool isfound) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Your answer: $input"),
              content: isfound
                  ? const Text(
                  "Codeword entered correctly")
                  : const Text("Incorrect"),
            actions: <Widget>[
              isfound
              ? TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApp()));}, child: const Text("Home"))
              : TextButton(onPressed: () {Navigator.of(context).pop();}, child: const Text("close")),
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

  Widget grid(var ui, List<String> words) {
    setupgrid(words);
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(maxWidth: min(ui.size.width, ui.size.height), maxHeight: min(ui.size.width, ui.size.height)),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (details) {
          changeLetterColor(details.localPosition.dx, details.localPosition.dy, ui);
          _dragX.add(details.localPosition.dx);
          _dragY.add(details.localPosition.dy);
        },
        onPanEnd: (details) {
          locateWord(ui);
          checkisright();
          clearSwipe();
        },
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
            shrinkWrap: true,
            crossAxisCount: gridSize,
        children: List.generate(gridSize*gridSize, (index) {
          return Container(
            constraints: BoxConstraints(maxWidth: min(ui.size.width, ui.size.height), maxHeight: min(ui.size.width, ui.size.height)),
            decoration: BoxDecoration(
              color: _userletters[index] ? Colors.yellow.shade200 : null,
            ),
            alignment: Alignment.center,
    child: ListTile(
    title: Text(_letters[index], style: _bigFont,),
    ),
          );
        }),
      ),
      ),
    );
  }

  void locateWord(var t) {
    double puzzleSize = min(t.size.width, t.size.height);

    double x0 = _dragX.first;
    double x1 = _dragX.last;
    double y0 = _dragY.first;
    double y1 = _dragY.last;

    int xstart = x0 ~/ (puzzleSize / gridSize);
    int xend = x1 ~/ (puzzleSize / gridSize);
    int ystart = y0 ~/ (puzzleSize / gridSize);
    int yend = y1 ~/ (puzzleSize / gridSize);

    if (ystart == yend){
      for (var i=xstart; i<=xend; i++ ){
        int a = i + (10 * ystart);
        if (_userletters[a]) {
          _saved.add(_letters[a]);
        }
      }
    }
    if (xstart == xend) {
      for (var i = ystart; i <= yend; i++) {
        int b = xstart + (10 * i);
        if (_userletters[b]) {
          _saved.add(_letters[b]);
        }
      }
    }
    _dragX.clear();
    _dragY.clear();

    }

    void clearSwipe() {
      for (var i = 0; i < _userletters.length; i++) {
        if (_userletters[i]) {
          setState(() {
            _userletters[i] = false;
          });
        }
      }
  }

  void changeLetterColor(double x, double y, var t) {
    double puzzleSize = min(t.size.width, t.size.height);

    int myx = x ~/ (puzzleSize / gridSize);
    int myy = y ~/ (puzzleSize / gridSize);
    int pos = myx + (gridSize * myy);
    setState(() {
      _userletters[pos] = true;
    });
  }

  Widget box() {
    return Column(children: <Widget>[
      Center(
        child: Text("Word Box", style: _biggerFont),
      ),
      Text("1. AARON", style: _bigFont),
      Text("2. AMIT", style: _bigFont),
      Text("3. BEN", style: _bigFont),
      Text("4. KATZ", style: _bigFont),
      Text("5. LUCAS", style: _bigFont),
      Text("6. SUMAARG", style: _bigFont)
    ]);
  }

  Widget interface(var ui, List<String> words) {
    return Column(
      children: <Widget>[
        grid(ui, words),
        SizedBox(height: ui.size.height / 44,),
        Divider(
          indent: ui.size.width / 12,
          endIndent: ui.size.width / 12,
          thickness: 3.0,
          color: Colors.black,
        ),
        //SizedBox(height: ui.size.height / 44,),
        //box(),
      ],
    );
  }

  void pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) {
            final Iterable<ListTile> tiles = _savedwords.map(
                (String text) {
                  return ListTile(
                    title: Text(text),
                  );
                },
            );
            final List<Widget> divided = ListTile.divideTiles(
                context: context,
                tiles: tiles).toList();
            return Scaffold(
              appBar: AppBar(
                title: const Text('Locate your password'),
              ),
              body: ListView(children: divided,),
              floatingActionButton: FloatingActionButton.extended(
                  onPressed: clear,
                  tooltip: 'Clear',
                  icon: const Icon(Icons.autorenew),
                  label: const Text("Restart"),
                elevation: 30.0,
                highlightElevation: 0.0,
              ),
            );
          },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var output = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(onPressed: pushSaved, icon: const Icon(Icons.arrow_forward_ios)),
        ],
      ),
      body: Builder(
        builder: (context) {
          return interface(output, _words);
        }),
    );
    }
  }

