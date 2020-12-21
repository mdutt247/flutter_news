class HomeDetailModel {
  String id;
  String title;
  String content;
  String type;
  String meta_data;
  String updated_at;

  HomeDetailModel(this.id, this.title, this.content, this.type, this.meta_data,
      this.updated_at);

  HomeDetailModel.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['post_id'].toString();
    this.title = jsonObject['post_title'];
    this.content = jsonObject['post_content'];
    this.type = jsonObject['post_type'];
    this.meta_data = jsonObject['post_meta'];
    this.updated_at = jsonObject['updated_at'];
  }
}