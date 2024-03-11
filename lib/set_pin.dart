import 'package:flutter/material.dart';
import 'package:wordsearch2fa/pin.dart';
import 'dart:math';

import 'package:wordsearch2fa/set_pword.dart';


class PinEntryPage extends StatefulWidget {

  const PinEntryPage({super.key, required this.title, required this.withMFA});
  final String title;
  final bool withMFA;

  @override
  PinEntryState createState() => PinEntryState();

}

class PinEntryState extends State<PinEntryPage> with SingleTickerProviderStateMixin {
  final List<String> _digits = <String>[];
  String pin = "";


  void addDigit(int digit) {
    if (_digits.length < 4) {
      setState(() {
        _digits.add(digit.toString());
      });
    }
  }

  void next() {
    print("bonjour");
    if (widget.withMFA) {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          PwordPage(title: "Choose keyword",
              pin: _digits.join(),
              withMFA: widget.withMFA)));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          PinTestPage(title: "Enter pin",
            pin: _digits.join(),
            withMFA: widget.withMFA,
            pword: '',)));
    }
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
            TextButton(onPressed: () {Navigator.of(context).pop();}, child: const Text("close")),
          ],


        );
      },
    );
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
      //constraints: BoxConstraints(maxWidth: maxSize, maxHeight: maxSize,),

      child: Column(
        children: <Widget>[

          Text(_digits.join(), style: const TextStyle(fontSize: 54),),

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
              ElevatedButton(onPressed: next, child: const Text("Y")),
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
            return Align(
              alignment: Alignment.center,
              child: interface(output),
            );

          }),
    );
  }
}

