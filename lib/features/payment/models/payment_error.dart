class PaymentErrorModel {
  String? property;
  String? error;

  PaymentErrorModel({
    this.property,
    required this.error,
  });

  factory PaymentErrorModel.fromJson(Map<String, dynamic> json) =>
      PaymentErrorModel(
        property: json["property"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "property": property,
        "error": error,
      };
}
