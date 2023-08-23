import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';

void main() async {
  var fetcher = AlbumListFetcher();
  try {
    var albums = await fetcher.fetchLatestAlbums();
    albums.forEach((element) {
      print(element.toString());
    });
  } on Exception catch (e) {
    print(e.toString());
  }
}

class AlbumListFetcher {
  Future<List<Album>> fetchLatestAlbums() async {
    List<Album> albums = [];
    var rawHtml = await fetchRawContent("https://www.xsnvshen.co/");
    BeautifulSoup soup = BeautifulSoup(rawHtml);
    var elements = soup.findAll("a", attrs: {"class": "itemimg"});
    for (var element in elements) {
      var albumUrl = "https://www.xsnvshen.co${element.getAttrValue("href")}";
      var title =
          "${element.getAttrValue("title")}".replaceAll("[XiuRen]高清写真图 ", "");
      var coverUrl =
          "https:${element.children.elementAt(0).getAttrValue("src")}";
      albums.add(Album(
          cover: coverUrl, url: albumUrl, title: title, description: title));
    }

    return albums;
  }

  Future<List<Album>> fetchAlbumPage(int pageNum) async {
    var param = pageNum > 1 ? "?p=$pageNum" : "";

    List<Album> albums = [];
    var rawHtml = await fetchRawContent("https://www.xsnvshen.co/album/$param");
    BeautifulSoup soup = BeautifulSoup(rawHtml);
    var elements = soup.findAll("a", attrs: {"class": "itemimg"});
    for (var element in elements) {
      var albumUrl = "https://www.xsnvshen.co${element.getAttrValue("href")}";
      var title =
          "${element.getAttrValue("title")}".replaceAll("[XiuRen]高清写真图 ", "");
      var coverUrl =
          "https:${element.children.elementAt(0).getAttrValue("src")}";
      albums.add(Album(
          cover: coverUrl, url: albumUrl, title: title, description: title));
    }

    return albums;
  }
}

class AlbumFetcher {
  Future<AlbumDetail> fetchDetail(String albumUrl) async {
    List<Photo> images = [];
    var rawHtml = await fetchRawContent(albumUrl);
    BeautifulSoup soup = BeautifulSoup(rawHtml);
    // title
    var title = soup.find("title")?.getText(strip: true);

    var elements = soup.findAll("img", attrs: {"class": "origin_image lazy"});
    var index = 0;
    for (var element in elements) {
      var url = "http:${element.getAttrValue("data-original")}";
      images.add(Photo(url, "${index++}.png"));
    }

    return AlbumDetail(albumUrl, title!, images);
  }

  Future<List<Photo>> fetchPhotos(String albumUrl) async {
    List<Photo> result = [];
    var rawHtml = await fetchRawContent(albumUrl);
    BeautifulSoup soup = BeautifulSoup(rawHtml);
    // title
    var title = soup.find("title")?.getText(strip: true);

    var elements = soup.findAll("img", attrs: {"class": "origin_image lazy"});
    var index = 0;
    for (var element in elements) {
      var url = "http:${element.getAttrValue("data-original")}";
      result.add(Photo(url, "${index++}.png"));
    }
    return result;
  }
}

Future<String> fetchRawContent(String albumUrl) async {
  var r = await http.get(Uri.parse(albumUrl), headers: {
    "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3",
    "Cookie":
        "__51uvsct__JNmoBsk0I91IZLwU=1; __51vcke__JNmoBsk0I91IZLwU=13db29d5-0d67-55c6-b686-fc6b2897289e; __51vuft__JNmoBsk0I91IZLwU=1690938938105; gcha_sf=1690938954; __51vcke__JNmlfXHHIrHMZgLq=4010e303-39eb-5fa9-86ed-269341da1985; __51vuft__JNmlfXHHIrHMZgLq=1690938956510; __PPU___PPU_SESSION_URL=%2Falbum%2F; jpx=1; __vtins__JNmlfXHHIrHMZgLq=%7B%22sid%22%3A%20%22e51a587d-7141-598f-af6b-230dc49a04bb%22%2C%20%22vd%22%3A%201%2C%20%22stt%22%3A%200%2C%20%22dr%22%3A%200%2C%20%22expires%22%3A%201691983273061%2C%20%22ct%22%3A%201691981473061%7D; __51uvsct__JNmlfXHHIrHMZgLq=6"
  });

  if (r.statusCode != 200) {
    throw Exception('GET $albumUrl throws $r.statusCode');
  }

  return r.body;
}

class Photo {
  final String url;
  final String name;

  Photo(this.url, this.name);

  @override
  String toString() {
    return "Photo(url= $url, name = $name)";
  }
}

class Album {
  const Album({
    required this.cover,
    required this.url,
    required this.title,
    required this.description,
  });

  final String cover;
  final String url;
  final String title;
  final String description;

  String albumNum() {
    return url.substring(url.lastIndexOf("/") + 1);
  }

  String parseBriefInfo() {
    var num = albumNum();
    var date = dateRegExp.stringMatch(title);
    return "相册编号: $num\n发布日期:$date";
  }

  @override
  String toString() {
    return 'Album{cover: $cover, url: $url, title: $title, description: $description}';
  }
}

class AlbumDetail {
  final String title;
  final List<Photo> images;
  final String url;

  AlbumDetail(this.url, this.title, this.images);
}

final dateRegExp = RegExp(r'^\d{4}\.\d{2}\.\d{2}');
