// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'logics/fetch_album.dart';

class AlbumImages extends StatelessWidget {
  final Album album;

  const AlbumImages(this.album, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text(album.title),
                      content: Text(album.parseBriefInfo()),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("关闭"),
                        ),
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.info_outline_rounded))
      ]),
      body: ImageList(album.url),
    );
  }
}

class ImageList extends StatefulWidget {
  final String albumUrl;

  const ImageList(this.albumUrl, {super.key});

  @override
  State<ImageList> createState() => _AlbumListState(albumUrl);
}

class _AlbumListState extends State<ImageList> with RestorationMixin {
  final String albumUrl;
  final RestorableBool _isSelected = RestorableBool(false);
  late Future<AlbumDetail> _future;

  _AlbumListState(this.albumUrl);

  @override
  String get restorationId => 'cards_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_isSelected, 'is_selected');
  }

  @override
  void dispose() {
    _isSelected.dispose();
    super.dispose();
  }

  @override
  void initState() {
    var fetcher = AlbumFetcher();
    _future = fetcher.fetchDetail(albumUrl);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder:
            (BuildContext context, AsyncSnapshot<AlbumDetail> detailFuture) {
          if (detailFuture.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${detailFuture.error}'),
                ),
              ],
            );
          } else if (detailFuture.hasData) {
            final detail = detailFuture.data!;
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  detail.title,
                  textDirection: TextDirection.ltr,
                ),
              ),
              body: Scrollbar(
                child: ListView(
                  restorationId: 'image_list_view',
                  padding: const EdgeInsets.only(top: 1, left: 8, right: 8),
                  children: [
                    for (final image in detail.images)
                      AspectRatio(
                        aspectRatio: 6 / 9,
                        child: Ink.image(
                            fit: BoxFit.fill,
                            image:
                                CachedNetworkImageProvider(image.url, headers: {
                              "User-Agent":
                                  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3",
                              "referer": detail.url
                            })),
                      ),
                  ],
                ),
              ),
            );
          } else {
            return const CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  automaticallyImplyLeading: true,
                  middle: Text("正在加载..."),
                ),
                child: Center(child: CupertinoActivityIndicator()));
          }
        });
  }
}
