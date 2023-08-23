import 'package:flutter/material.dart';

import 'widgets/basic_album_elements.dart';
import 'logics/fetch_album.dart';
import 'widgets/future_builder_items.dart';
import 'nav_drawer.dart';

void main() {
  runApp(const MaterialApp(home: AlbumGrid()));
}

class AlbumGrid extends StatelessWidget {
  const AlbumGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: AlbumGridView());
  }
}

class AlbumGridView extends StatefulWidget {
  const AlbumGridView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AlbumGridViewState();
  }
}

class _AlbumGridViewState extends State<AlbumGridView> {
  late Future<List<Album>> _future;

  @override
  void initState() {
    var fetcher = AlbumListFetcher();
    _future = fetcher.fetchLatestAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<List<Album>> snapshot) {
          if (snapshot.hasError) {
            return genErrorColumn(snapshot.error);
          } else if (snapshot.hasData) {
            List<Album> albums = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: const Text("最近新上"),
              ),
              body: GridView.count(
                restorationId: 'recent_albums_grid',
                crossAxisCount: 2,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 0.6,
                padding: const EdgeInsets.all(2),
                shrinkWrap: true,
                children: albums.map((e) => AlbumItem(album: e)).toList(),
              ),
              drawer: const NavDrawer(),
            );
          } else {
            return genLoadingScaffold();
          }
        });
  }
}




