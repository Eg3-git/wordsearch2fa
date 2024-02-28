import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart';
import 'dart:math';
//import 'package:cloud_firestore/cloud_firestore.dart';

const int grid_size = 10;

class WordsearchPage extends StatefulWidget {

  WordsearchPage({Key? key, required this.title}) : super(key: key);
  final String title;

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

  final String correct_word = "horses";

  void setupgrid(List<String> words) {
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
    //bool done = false;

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

  Widget grid(var ui, List<String> words) {
    setupgrid(words);
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(maxWidth: min(ui.size.width, ui.size.height), maxHeight: min(ui.size.width, ui.size.height)),
      child: GestureDetector(
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
          primary: false,
            shrinkWrap: true,
            crossAxisCount: grid_size,
        children: List.generate(grid_size*grid_size, (index) {
          return Container(
            decoration: new BoxDecoration(
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
    double x0 = _dragX.first;
    double x1 = _dragX.last;
    double y0 = _dragY.first;
    double y1 = _dragY.last;
    int xstart = 0;
    int xend = 0;
    int ystart = 0;
    int yend = 0;
    xstart = x0 ~/ (t.size.width / grid_size);
    xend = x1 ~/ (t.size.width / grid_size);
    ystart = y0 ~/ (t.size.width / grid_size);
    yend = y1 ~/ (t.size.width / grid_size);

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
    int myx = x ~/ (t.size.width / grid_size);
    int myy = y ~/ (t.size.width / grid_size);
    int pos = myx + (10 * myy);
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
    return Container(
      child: Column(
        children: <Widget>[
          grid(ui, words),
          SizedBox(height: ui.size.height / 44,),
          Divider(
            indent: ui.size.width / 12,
            endIndent: ui.size.width / 12,
            thickness: 3.0,
            color: Colors.black,
          ),
          SizedBox(height: ui.size.height / 44,),
          box(),
        ],
      ),
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
                title: Text('Locate your password'),
              ),
              body: ListView(children: divided,),
              floatingActionButton: FloatingActionButton.extended(
                  onPressed: clear,
                  tooltip: 'Clear',
                  icon: Icon(Icons.autorenew),
                  label: Text("Restart"),
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
          IconButton(onPressed: pushSaved, icon: Icon(Icons.arrow_forward_ios)),
        ],
      ),
      body: Builder(
        builder: (context) {
          return interface(output, _words);
        }),
    );
    }
  }

