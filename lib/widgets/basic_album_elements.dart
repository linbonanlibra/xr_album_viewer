import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../logics/fetch_album.dart';
import '../list_album_images.dart';

class AlbumItem extends StatelessWidget {
  const AlbumItem({super.key, required this.album, this.shape});

  final Album album;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black45,
        title: _GridTitleText(album.title),
        trailing: IconButton(
          icon: const Icon(Icons.read_more),
          iconSize: 15,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AlbumImages(album)));
          },
        ),
      ),
      child: AlbumCover(album: album),
    );
  }
}

class AlbumCover extends StatelessWidget {
  const AlbumCover({super.key, required this.album});

  final Album album;

  @override
  Widget build(BuildContext context) {
    return Ink.image(
      image: CachedNetworkImageProvider(album.cover, headers: {
        "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3",
        "referer": "https://www.xsnvshen.co"
      }),
      fit: BoxFit.fitHeight,
      child: Container(),
    );
  }
}

class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fill,
      alignment: AlignmentDirectional.centerStart,
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}