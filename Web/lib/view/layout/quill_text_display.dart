import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:convert';

class QuillTextDisplay extends StatelessWidget {
  final String text;

  QuillTextDisplay({required this.text});

  @override
  Widget build(BuildContext context) {
    var deltaJson = jsonDecode(text);

    final quill.Document document = quill.Document.fromJson(deltaJson);

    final quill.QuillController _controller = quill.QuillController(
      document: document,
      selection: TextSelection.collapsed(offset: 0),
      readOnly: true, 
    );

    return quill.QuillEditor.basic(
      controller: _controller,
    );
  }
}
