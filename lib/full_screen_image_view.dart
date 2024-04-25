import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onClose;

  FullScreenImageView({required this.imageUrl, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
             onClose();
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: GestureDetector(
        onTap: onClose,
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}
