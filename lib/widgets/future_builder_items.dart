import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Column genErrorColumn(Object? error) {
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
        child: Text('Error: ${error}'),
      ),
    ],
  );
}

CupertinoPageScaffold genLoadingScaffold() {
  return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        middle: Text("正在加载..."),
      ),
      child: Center(child: CupertinoActivityIndicator()));
}
