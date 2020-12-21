class HomeModel {
  String id;
  String title;
  String color;

  HomeModel(this.id, this.title, this.color);

  HomeModel.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['category_id'].toString();
    this.title = jsonObject['category_title'];
    this.color = jsonObject['category_color'];
  }
}
