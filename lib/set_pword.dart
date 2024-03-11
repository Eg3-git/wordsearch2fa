import 'package:flutter/material.dart';
import 'package:wordsearch2fa/pin.dart';
import 'package:wordsearch2fa/wordsearch.dart';

class PwordPage extends StatefulWidget {
  const PwordPage({super.key, required this.title, required this.pin, required this.withMFA});
  final String title;
  final String pin;
  final bool withMFA;

  @override
  PwordState createState() => PwordState();

}


class PwordState extends State<PwordPage> with SingleTickerProviderStateMixin {
  bool isVisible = false;
  bool hasFailed = false;
  String pword = "";
  final TextEditingController field1 = TextEditingController();
  final TextEditingController field2 = TextEditingController();

  void setPword() {
    if (field1.text != field2.text) {
      setState(() {
        hasFailed = true;
      });
    } else {
      setState(() {
        pword = field1.text;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => PinTestPage(title: "Enter pin", pword: pword, pin: widget.pin, withMFA: widget.withMFA,)));
    }
  }

  Widget interface(var ui) {
    return Column(
      children: <Widget>[
        TextField(
          controller: field1,
          obscureText: isVisible,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            hintText: "Set a Keyword",
            labelText: "Keyword",
            helperText: "Please enter a keyword",
            helperStyle: const TextStyle(color: Colors.green),
            suffixIcon: IconButton(
              icon: Icon(isVisible
                ? Icons.visibility
                : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
            ),
              alignLabelWithHint: false,
              filled: true
          ),
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
        ),

        TextField(
          controller: field2,
          obscureText: isVisible,
          decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              hintText: "Confirm Password",
              labelText: "Confirm",
              helperText: "Please confirm your keyword",
              helperStyle: const TextStyle(color: Colors.green),
              suffixIcon: IconButton(
                icon: Icon(isVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              ),
              alignLabelWithHint: false,
            filled: true
          ),
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
        ),

        if (hasFailed) const Text("Keywords do not match. Please try again."),


        ElevatedButton(onPressed: setPword, child: const Text("Set Keyword"))


      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var ui = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (context) {
          return interface(ui);
        },
      ),
    );
  }
}