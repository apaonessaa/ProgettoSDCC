import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsweb/model/retrive_data.dart';

class ImageViewer extends StatefulWidget 
{
    final String title;  
    ImageViewer({required this.title});
    @override
    _ImageViewer createState() => _ImageViewer();
}

class _ImageViewer extends State<ImageViewer> 
{
    late Future<Uint8List> imageBytes; 

    Future<Uint8List> fetchImage(String title) async 
    {
        try {
            return await RetriveData.sharedInstance.getImage(title);
        } catch (e) {
            throw Exception('Failed to load image: $e');
        }
    }

    @override
    void initState() 
    {
        super.initState();
        imageBytes = fetchImage(widget.title);
    }

    @override
    void didUpdateWidget(covariant ImageViewer oldWidget) {
        super.didUpdateWidget(oldWidget);

        if (oldWidget.title != widget.title) {
            setState(() {
                imageBytes = fetchImage(widget.title);
            });
        }
    }

    @override
    Widget build(BuildContext context) 
    {
        return Center(
            child: FutureBuilder<Uint8List>(
            future: imageBytes,
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); 
                }
                else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                }
                else if (snapshot.hasData) {
                    return Image.memory(snapshot.data!);
                }
                else {
                    return Text('No image available');
                }
            },),
        );
    }
}
