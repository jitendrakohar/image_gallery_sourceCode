import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_gallery/full_screen_image_view.dart';
import 'package:image_gallery/model/imageItem.dart';
import 'package:http/http.dart' as http;


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<ImageModel> _images;
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  late int _page;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _images = [];
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _page = 1;
    _fetchImages();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchImages() async {
    if (_loading) return;
    setState(() => _loading = true);

    String apiKey = "43576548-cb0cf9a9b7065cc5f66c469a0";
    const String baseUrl = 'https://pixabay.com/api/';
    final String query = _searchController.text;
    const int perPage = 32;

    final response = await http.get(Uri.parse(
        '$baseUrl?key=$apiKey&q=$query&page=$_page&per_page=$perPage'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<ImageModel> images = (data['hits'] as List)
          .map((item) => ImageModel(
              imageUrl: item['webformatURL'],
              imageName: item['tags'],
              likes: item['likes'],
              views: item['views']))
          .toList();

      setState(() {
        _images.addAll(images);
        _loading = false;
        _page++;
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 500) {
      _fetchImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _images.clear();
              _page = 1;
            });
            _fetchImages();
          },
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width<900?(MediaQuery.of(context).size.width<500?MediaQuery.of(context).size.width ~/ 250: MediaQuery.of(context).size.width ~/ 200): MediaQuery.of(context).size.width ~/ 220,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                final image = _images[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullScreenImageView(
                                imageUrl: image.imageUrl,
                                onClose: () {
                                  Navigator.of(context).pop();
                                },
                              )),
                    );
                  },
                  child: Container(

                    color: const Color(0xffDE9EB4FF),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                                height: 200,
                                child: Center(
                                  child: Image.network(
                                    image.imageUrl,
                                    fit: BoxFit.fitWidth,
                                  ),
                                )),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                  color: Colors.black26,
                                  child: Text(
                                    "${image.imageName}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white),
                                  )),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.thumb_up),
                                Text("${image.likes}")
                              ],
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Row(
                              children: [
                                Text("${image.views}"),
                                const Icon(Icons.remove_red_eye_sharp)
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
