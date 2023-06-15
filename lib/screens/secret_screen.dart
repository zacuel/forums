import 'package:flutter/material.dart';
import '../utilities/usernames.dart';

//TODO get secret screen for phone app
class addNameWords extends StatefulWidget {
  static const routeName = '/drowssap';
  const addNameWords({super.key});

  @override
  State<addNameWords> createState() => _addNameWordsState();
}

class _addNameWordsState extends State<addNameWords> {
  var _whichWordType = WordType.adjective;
  final _wordController = TextEditingController();
  final _nameEngine = NameEngine();

  @override
  void initState() {
    super.initState();
    _nameEngine.retrieveAllWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("somethings not working"),
      ),
      body: Column(
        children: [
          RadioListTile<WordType>(
            title: Text('adjective'),
            value: WordType.adjective,
            groupValue: _whichWordType,
            onChanged: (value) {
              setState(() {
                _whichWordType = value!;
              });
            },
          ),
          RadioListTile<WordType>(
            title: Text('Noun'),
            value: WordType.noun,
            groupValue: _whichWordType,
            onChanged: (value) {
              setState(() {
                _whichWordType = value!;
              });
            },
          ),
          TextField(controller: _wordController),
          TextButton(
              onPressed: () =>
                  _nameEngine.addWord(_whichWordType, _wordController.text),
              child: Icon(Icons.abc)),
        ],
      ),
    );
  }
}
