import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(ImageGalleryApp());
}

class ImageGalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ImageGalleryScreen(),
    );
  }
}

class ImageGalleryScreen extends StatefulWidget {
  @override
  _ImageGalleryScreenState createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _images.insert(0, File(pickedFile.path)); // New images appear first
      });
    }
  }

  void _showFullImage(File image, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(image: image, tag: "image$index"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Gallery 📷")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: _images.isEmpty
            ? Center(
                child: Text(
                  "No images added yet!",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showFullImage(_images[index], index),
                    child: Hero(
                      tag: "image$index",
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_images[index], fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.camera_alt),
            onPressed: () => _pickImage(ImageSource.camera),
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            backgroundColor: Colors.green,
            child: Icon(Icons.photo_library),
            onPressed: () => _pickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final File image;
  final String tag;
  FullScreenImage({required this.image, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: Hero(
          tag: tag,
          child: Image.file(image),
        ),
      ),
    );
  }
}
