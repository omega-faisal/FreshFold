import 'package:flutter/material.dart';
import '../utils/image_res.dart';

Widget appImage(
    {String imagePath = ImageRes.idIcon,
    double width = 16,
    double height = 16}) {
  return Image.asset(
    imagePath,
    width: width,
    height: height,
  );
}

Widget appImageWithColor(
    {String imagePath = ImageRes.idIcon,
    double width = 16,
    double height = 16,
    Color imageColor = Colors.white}) {
  return Image.asset(
    imagePath,
    width: width,
    height: height,
    color: imageColor,
  );
}

// class circularProfileImage extends StatefulWidget {
//    circularProfileImage({super.key,required this.radius,required this.imagePath});
//
//   double radius;
//   String? imagePath;
//
//   @override
//   State<circularProfileImage> createState() => _circularProfileImageState();
// }
// class _circularProfileImageState extends State<circularProfileImage> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         child: CircleAvatar(
//           radius: widget.radius,
//           backgroundImage: (widget.imagePath != null)
//               ? NetworkImage(
//             widget.imagePath!,
//           )
//               : NetworkImage(
//             "https://as2.ftcdn.net/v2/jpg/00/89/55/15/1000_F_89551596_LdHAZRwz3i4EM4J0NHNHy2hEUYDfXc0j.jpg",
//           ),
//         ),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: Color.fromARGB(255, 0, 7, 112),
//             width: 1.0,
//           ),
//         ),
//       ),
//     );
//   }
// }



//Widget circularProfileImage({double radius = 80, String? imagePath}) {
