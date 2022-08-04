// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
//
// List<CameraDescription> cameras = [];
//
// class Camera extends StatefulWidget {
//   const Camera({Key? key}) : super(key: key);
//
//   @override
//   State<Camera> createState() => _CameraState();
// }
//
// class _CameraState extends State<Camera> {
//   late CameraController _cameraController;
//   late Future<void> cameraValue;
//
//   @override
//   void initState() {
//     super.initState();
//     _cameraController = CameraController(cameras[0], ResolutionPreset.high);
//     cameraValue = _cameraController.initialize();
//   }
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           FutureBuilder(
//               future: cameraValue,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return CameraPreview(_cameraController);
//                 } else {
//                   return Center(child: CircularProgressIndicator());
//                 }
//               }),
//           Positioned(
//             bottom: 0.0,
//             child: Container(
//               height: 100,
//               color: Colors.black,
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 30),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         IconButton(
//                             onPressed: () {},
//                             icon: Icon(
//                               Icons.flash_off,
//                               color: Colors.white,
//                               size: 28,
//                             )),
//                         IconButton(
//                             onPressed: () {},
//                             icon: Icon(
//                               Icons.panorama_fish_eye,
//                               color: Colors.white,
//                               size: 70,
//                             )),
//                         IconButton(
//                             onPressed: () {},
//                             icon: Icon(
//                               Icons.flip_camera_android,
//                               color: Colors.white,
//                               size: 28,
//                             )),
//                       ],
//                     ),
//                   ),
//                   Text(
//                     'Tap for photp,Hold for Video',
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                     textAlign: TextAlign.center,
//                   )
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
