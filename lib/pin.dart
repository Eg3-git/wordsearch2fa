import 'package:flutter/material.dart';
import 'package:wordsearch2fa/main.dart';
import 'package:wordsearch2fa/set_pword.dart';
import 'dart:math';

import 'package:wordsearch2fa/wordsearch.dart';


class PinTestPage extends StatefulWidget {

  const PinTestPage({super.key, required this.title, required this.pword, required this.pin, required this.withMFA});
  final String title;
  final String pword;
  final String pin;
  final bool withMFA;

  @override
  PinTestState createState() => PinTestState();

}

class PinTestState extends State<PinTestPage> with SingleTickerProviderStateMixin {
  final List<String> _digits = <String>[];
  String pin = "";
  final DateTime start = DateTime.now();


  void addDigit(int digit) {
    if (_digits.length < 4) {
      setState(() {
        _digits.add(digit.toString());
      });
    }
  }

  void checkIsRight() {
    String entered = _digits.join();
    print("entered: $entered actual: ${widget.pin}");
    showMessage(entered == widget.pin);
    clear();

  }

  void showMessage(bool isCorrect) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: isCorrect
          ? small()
          : const Text("Pin incorrect"),
          content: isCorrect
              ? const Text(
              "Move onto 2fa")
              : const Text("Try again"),
          actions: <Widget>[messageHandler(isCorrect)],


        );
      },
    );
  }

  Widget small() {
    //print(start);
    print(DateTime.now().difference(start));
    return const Text("Pin entered correctly");
  }

  
  Widget messageHandler(isCorrect){
    if (isCorrect){
      if (widget.withMFA){
        return TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => WordsearchPage(title: "Wordsearch", pword: widget.pword,)));}, child: const Text("Go to MFA"),);
      } else {
        return TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApp()));}, child: const Text("Home"),);
      }
    } else {
      return TextButton(onPressed: () {Navigator.of(context).pop();}, child: const Text("close"));
    }
  }

  void clear() {
    setState(() {
      _digits.clear();
    });

  }

  Widget grid(var ui) {
    double maxSize = min(ui.size.width, ui.size.height);

    return Container(
        alignment: Alignment.center,
        width: maxSize * 0.9,
        height: maxSize * 0.9,
        //constraints: BoxConstraints(maxWidth: min(ui.size.width, ui.size.height), maxHeight: min(ui.size.width, ui.size.height)),

        child: Column(
          children: [
            Text(_digits.join().replaceAll(RegExp(r"."), "⬮"),  style: const TextStyle(fontSize: 54),),

            const Spacer(),
            Row(
              children: <Widget>[
                TextButton(onPressed: () {addDigit(1);}, child: const Text("1")),
                TextButton(onPressed: () {addDigit(2);}, child: const Text("2")),
                TextButton(onPressed: () {addDigit(3);}, child: const Text("3")),
              ],
            ),

            Row(
              children: <Widget>[
                TextButton(onPressed: () {addDigit(4);}, child: const Text("4")),
                TextButton(onPressed: () {addDigit(5);}, child: const Text("5")),
                TextButton(onPressed: () {addDigit(6);}, child: const Text("6")),
              ],
            ),

            Row(
              children: <Widget>[
                ElevatedButton(onPressed: clear, child: const Text("C")),
                TextButton(onPressed: () {addDigit(0);}, child: const Text("0")),
                ElevatedButton(onPressed: checkIsRight, child: const Text("Y")),
              ],
            ),
          ],
        )
    );

  }



  Widget interface(var ui) {
    return Column(
      children: <Widget>[
        grid(ui),
        //SizedBox(height: ui.size.height / 44,),
        Divider(
          indent: ui.size.width / 12,
          endIndent: ui.size.width / 12,
          thickness: 3.0,
          color: Colors.black,
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var output = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),

      ),
      body: Builder(
          builder: (context) {
            return interface(output);
          }),
    );
  }
}

