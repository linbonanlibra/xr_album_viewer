import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets/basic_album_elements.dart';
import 'logics/fetch_album.dart';
import 'nav_drawer.dart';

class PageAlbumList extends StatelessWidget {
  const PageAlbumList({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AlbumsOfPage());
  }
}

class AlbumsOfPage extends StatefulWidget {
  const AlbumsOfPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AlbumsOfPageState();
  }
}

class _AlbumsOfPageState extends State<AlbumsOfPage> with RestorationMixin {
  final RestorableBool _isSelected = RestorableBool(false);

  ScrollController scrollController = ScrollController();
  bool _loading = false;

  var fetcher = AlbumListFetcher();
  late Future<List<Album>> _future;
  int curPage = 1;

  @override
  void initState() {
    _future = fetcher.fetchAlbumPage(curPage);

    scrollController.addListener(() {
      var distToBottom = scrollController.position.maxScrollExtent -
          scrollController.position.pixels;
      if (distToBottom < 300 && !_loading) {
        loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<List<Album>> snapshot) {
          if (snapshot.hasError) {
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
                  child: Text('Error: ${snapshot.error}'),
                ),
              ],
            );
          } else if (snapshot.hasData) {
            _loading = false;
            List<Album> albums = snapshot.data!;
            return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                  title: const Text(
                    '画廊',
                    textDirection: TextDirection.ltr,
                  ),
                ),
                body: Scrollbar(
                  controller: scrollController,
                  child: ListView(
                    controller: scrollController,
                    restorationId: 'album_list_view',
                    children: [
                      for (final album in albums) AlbumItem(album: album),
                    ],
                  ),
                ),
                drawer: const NavDrawer());
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


  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future<void> loadMore() async {
    _loading = true;
    curPage++;
    setState(() {
      _future = fetcher.fetchAlbumPage(curPage);
    });
  }

  @override
  String? get restorationId => "_AlbumsOfPageState";

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_isSelected, 'is_selected');
  }
}
