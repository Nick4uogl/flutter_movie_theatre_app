class TicketModel {
  int id;
  int movieId;
  String name;
  int date;
  int seatIndex;
  int rowIndex;
  String roomName;
  String image;
  String smallImage;

  TicketModel({
    required this.id,
    required this.movieId,
    required this.name,
    required this.date,
    required this.seatIndex,
    required this.rowIndex,
    required this.roomName,
    required this.image,
    required this.smallImage,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
        id: json["id"],
        movieId: json["movieId"],
        name: json["name"],
        date: json["date"],
        seatIndex: json["seatIndex"],
        rowIndex: json["rowIndex"],
        roomName: json["roomName"],
        image: json["image"],
        smallImage: json["smallImage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "movieId": movieId,
        "name": name,
        "date": date,
        "seatIndex": seatIndex,
        "rowIndex": rowIndex,
        "roomName": roomName,
        "image": image,
        "smallImage": smallImage,
      };
}
