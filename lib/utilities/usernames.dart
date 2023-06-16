import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'package:http/http.dart' as http;

enum WordType { adjective, noun }

//TODO factor name generator out of project.
class NameEngine {
  List<String> _adjectives = [];
  List<String> _nouns = [];

  Future<void> addWord(WordType whichWordType, String word) async {
    var urlSegment;
    var whichList;
    if (whichWordType == WordType.noun) {
      _nouns.add(word);
      whichList = _nouns;
      urlSegment = 'nouns';
    } else {
      _adjectives.add(word);
      whichList = _adjectives;
      urlSegment = 'adjectives';
    }
    final url = Uri.parse(
        'https://ydtwo-8550b-default-rtdb.firebaseio.com/words/$urlSegment.json');

    try {
      await http.put(url, body: json.encode(whichList));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> retrieveAllWords() async {
    //called in initState() of secret_screen.
    final adjectiveUrl = Uri.parse(
        'https://ydtwo-8550b-default-rtdb.firebaseio.com/words/adjectives.json');
    final nounUrl = Uri.parse(
        'https://ydtwo-8550b-default-rtdb.firebaseio.com/words/nouns.json');
    final adjectiveResponse = await http.get(adjectiveUrl);
    final nounResponse = await http.get(nounUrl);

    final adjectiveData = json.decode(adjectiveResponse.body);
    final nounData = json.decode(nounResponse.body);
    if (adjectiveData != null) {
      _adjectives = List.castFrom(adjectiveData);
    }
    if (nounData != null) {
      _nouns = List.castFrom(nounData);
    }
  }

  static Future<void> createAlias(String userId) async {
    final theAlias = await _newUserName;
    final url = Uri.parse(
        'https://ydtwo-8550b-default-rtdb.firebaseio.com/users/$userId.json');
    try {
      await http.put(url, body: json.encode({'userAlias': theAlias}));
    } catch (error) {
      rethrow;
    }
  }

  static Future<String> get _newUserName async {
    final adjectiveUrl = Uri.parse(
        'https://ydtwo-8550b-default-rtdb.firebaseio.com/words/adjectives.json');
    final nounUrl = Uri.parse(
        'https://ydtwo-8550b-default-rtdb.firebaseio.com/words/nouns.json');
    var adjectiveResponse;
    var nounResponse;
    try {
      adjectiveResponse = await http.get(adjectiveUrl);
      nounResponse = await http.get(nounUrl);
    } catch (error) {
      rethrow;
    }
    final theAdjectives = List.castFrom(json.decode(adjectiveResponse.body));
    final theNouns = List.castFrom(json.decode(nounResponse.body));
    final theAdjective = theAdjectives[Random().nextInt(theAdjectives.length)];
    final theNoun = theNouns[Random().nextInt(theNouns.length)];

    return Future(() => '$theAdjective$theNoun');
  }
}
