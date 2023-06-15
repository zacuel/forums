import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import './personal_page.dart';
import '../constants.dart';

//TODO better organization for create_content/create_post

class CreateContentScreen extends StatefulWidget {
  final String title;
  final bool isOriginal;
  final String exciteLine;
  final Locale locale;
  //TODO add bool for validation message
  const CreateContentScreen({
    super.key,
    required this.title,
    required this.isOriginal,
    required this.exciteLine,
    required this.locale,
  });

  @override
  State<CreateContentScreen> createState() => _CreateContentScreenState();
}

class _CreateContentScreenState extends State<CreateContentScreen> {
  final _urlController = TextEditingController();
  final _contentController = TextEditingController();

  //TODO this can be a stateless widget due to it's connection with create_post_screen

  Future<void> _postArticle() async {
    //TODO url validation
    if ((!widget.isOriginal && _urlController.text.trim().isEmpty) ||
        (widget.isOriginal && _contentController.text.trim().isEmpty)) {
      return;
    }
    await Provider.of<Articles>(context, listen: false)
        .createArticle(
          //TODO error handling here
          Article(
            locale: widget.locale,
            id: '',
            isOriginal: widget.isOriginal,
            title: widget.title,
            exciteLine: widget.exciteLine,
            articleUrl: _urlController.text.trim().isNotEmpty
                ? _urlController.text
                : null,
            content: _contentController.text.trim().isNotEmpty
                ? _contentController.text
                : null,
            creationDate: DateTime.now(),
          ),
        )
        .then(
          (value) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Success!"),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.of(context)
                        .popUntil(ModalRoute.withName(PersonalPage.routeName)),
                    child: Text('OK'))
              ],
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Content")),
      body: Column(children: [
        if (!widget.isOriginal)
          TextField(
            controller: _urlController,
            decoration: InputDecoration(hintText: 'url goes here'),
          ),
        TextField(
          minLines: 10,
          maxLines: 10,
          controller: _contentController,
          //TODO keep content from flipping pages.
          decoration: InputDecoration(hintText: 'content goes here'),
        ),
        ElevatedButton(
          onPressed: _postArticle,
          child: Text("Post Article!"),
        )
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _urlController.dispose();
    _contentController.dispose();
  }
}
