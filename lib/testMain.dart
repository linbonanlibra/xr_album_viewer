

void main() {
  const title = "2023.08.17 sdsd";
  final reg = RegExp(r'^\d{4}\.\d{2}\.\d{2}');
  final match = reg.stringMatch(title);
  print("match: ${reg.stringMatch(title)}");

}


