import 'package:dumb_flutter/page_albums.dart';
import 'package:flutter/material.dart';

import 'recent_albums.dart';

class NavDrawer extends StatelessWidget{
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerItems = ListView(
      children: [
        const Text("XR"),
        ListTile(
          title: const Text("最新发布"),
          leading: const Icon(Icons.photo_album_outlined),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AlbumGrid()));
          },
        ),
        ListTile(
          title: const Text("列表"),
          leading: const Icon(Icons.person_pin_circle_outlined),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PageAlbumList()));
          },
        )
      ],
    );

    return Drawer(child: drawerItems);
  }

}