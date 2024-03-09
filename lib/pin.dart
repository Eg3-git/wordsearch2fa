import 'package:flutter/material.dart';
import 'package:wordsearch2fa/main.dart';
import 'package:wordsearch2fa/set_pword.dart';
import 'dart:math';


class PinTestPage extends StatefulWidget {

  const PinTestPage({super.key, required this.title, required this.pin, required this.withMFA});
  final String title;
  final String pin;
  final bool withMFA;

  @override
  PinTestState createState() => PinTestState();

}

class PinTestState extends State<PinTestPage> with SingleTickerProviderStateMixin {
  final List<String> _digits = <String>[];
  String pin = "";


  void addDigit(int digit) {
    if (_digits.length < 4) {
      setState(() {
        _digits.add(digit.toString());
      });
    }
  }

  void checkIsRight() {
    showMessage(_digits.join() == widget.pin);
    clear();

  }

  void showMessage(bool isCorrect) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: isCorrect
          ? const Text("Pin entered correctly")
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
  
  Widget messageHandler(isCorrect){
    if (isCorrect){
      if (widget.withMFA){
        return TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const PwordPage(title: "Wordsearch")));}, child: const Text("Go to MFA"),);
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

