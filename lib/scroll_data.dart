class ListData {
  final int i;
  final String name;

  ListData(this.i, this.name);
}

final listData = generate();

List<ListData> generate() {
  return List.generate(1000, (i) => ListData(i, "$i"));
}
