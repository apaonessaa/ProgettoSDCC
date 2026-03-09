import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class FormUtils 
{
    static void gotoAdminDialog(BuildContext context, String title, String content, List<Widget> actions) 
    {
        showDialog(
            context: context,
            builder: (BuildContext _context) {
                return AlertDialog(
                    title: Text(title),
                    content: Text(content),
                    actions: actions,
                );
            },
        );
    }

    static Widget buildDialogHeader(String title) 
    {
        return Container(
            decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16))),
                    const Icon(Icons.category, color: Colors.white),
                ],
            ),
        );
    }

    static void openFilterDialogCategory(BuildContext context, String title, List<Widget> widgets) async 
    {
        await showDialog(
            context: context,
            builder: (context) {
                return StatefulBuilder(
                    builder: (context, setDialogState) {
                        return AlertDialog(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            titlePadding: EdgeInsets.zero,
                            title: FormUtils.buildDialogHeader(title),
                            content: SingleChildScrollView(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                                spacing: 8.0,
                                children: widgets
                                ),
                            ),
                        );
                    },
                );
            },
        );
    }

    static void openFilterDialogSubcategories(BuildContext context, String title, List<Widget> widgets) async 
    {
        await showDialog(
            context: context,
            builder: (context) {
                return StatefulBuilder(
                    builder: (context, setDialogState) {
                        return AlertDialog(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            titlePadding: EdgeInsets.zero,
                            title: FormUtils.buildDialogHeader(title),
                            content: SingleChildScrollView(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
                                    spacing: 8.0,
                                    children: widgets
                                ),
                            ),
                            actions: [
                                TextButton(
                                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Ok'),
                                ),
                            ],
                        );
                    },
                );
            },
        );
    }

    static quill.QuillController initQuillController(String value) 
    {
        try {
            final decoded = jsonDecode(value);
            return quill.QuillController(
                document: quill.Document.fromJson(decoded),
                selection: const TextSelection.collapsed(offset: 0),
            );
        } catch (e) {
            return quill.QuillController(
                document: quill.Document()..insert(0, value),
                selection: const TextSelection.collapsed(offset: 0),
            );
        }
    }
}