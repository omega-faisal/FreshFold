class CarouselItem {
  final String index;
  final String img;
  final String description;
  final String route;

  CarouselItem({
    required this.index,
    required this.img,
    required this.description,
    required this.route,
  });

  factory CarouselItem.fromJson(Map<String, dynamic> json) {
    return CarouselItem(
      index: json['serviceId'],
      img: json['img'],
      description: json['description'],
      route: json['route'],
    );
  }
}
