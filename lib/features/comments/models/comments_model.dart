class CommentModel {
  int id;
  String? author;
  String? content;
  int? rating;
  bool isMy;

  CommentModel({
    required this.id,
    required this.author,
    required this.content,
    required this.rating,
    required this.isMy,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        author: json["author"],
        content: json["content"],
        rating: json["rating"],
        isMy: json["isMy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "content": content,
        "rating": rating,
        "isMy": isMy,
      };
}
