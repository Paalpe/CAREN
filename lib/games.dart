// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// Future<List<Photo>> fetchPhotos(http.Client client) async {
//   var request =
//       http.Request('GET', Uri.parse('https://itch.io/jam/328643/entries.json'));
//   List<Photo> photos = [];
//   var response = request.send();

//   var body =  response
//       .then((value) => value.stream.bytesToString());
//       // then((value) =>
//       //     jsonDecode(value)['jam_games']
//       //         .map((element) => Photo.fromJson(element))
//       //         .toList()));
//       // .then((value) => value.forEach((element) {
//       //       // print(element.title);
//       //       return photos.add(element);
//       //     }));
//   // return photos;
//   // then((value) => value.stream.bytesToString().then((value) =>
//   //       jsonDecode(value)['jam_games']
//   //         .map((element) => Photo.fromJson(element))
//   //         .toList())).then((value) => photos = value);

//   // return photos;
//   // final response =
//   //     await client.get(Uri.parse('https://itch.io/jam/328643/entries.json'));
//   // //     .catchError((e) {
//   // //   print(e.toString());
//   // // });
//   // // Use the compute function to run parsePhotos in a separate isolate.
//   return compute(parsePhotos as ComputeCallback<Future<String>, List<Photo>>, body);
//   // // return parsePhotos(response.body);
// }

// // A function that converts a response body into a List<Photo>.
// List<Photo> parsePhotos(String responseBody) {
//   final parsed = jsonDecode(responseBody); //.cast<Map<String, dynamic>>();
//   // print(parsed['jam_games'].map((element) => Photo.fromJson(element)).toList());

//   return parsed['jam_games'].map((element) => Photo.fromJson(element)).toList();
// }

// class Photo {
//   final int albumId;
//   final int id;
//   final String title;
//   final String url;
//   final String thumbnailUrl;

//   const Photo({
//     required this.albumId,
//     required this.id,
//     required this.title,
//     required this.url,
//     required this.thumbnailUrl,
//   });

//   factory Photo.fromJson(Map<String, dynamic> json) {
//     return Photo(
//       albumId: json['id'] as int,
//       id: json['id'] as int,
//       title: json['game']['title'] as String,
//       url: json['game']['url'] as String,
//       thumbnailUrl: json['game']['cover'] as String,
//     );
//   }
// }

// class MyHomePageNew extends StatelessWidget {
//   const MyHomePageNew({super.key, required this.title});

//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: CustomScrollView(semanticChildCount: 4, slivers: <Widget>[
        
//         SliverFillRemaining(
//           child: FutureBuilder<List<Photo>>(
//             future: fetchPhotos(http.Client()),
//             builder: (context, snapshot) {
//               print(snapshot);
        
//               if (snapshot.hasError) {
//                 return const Center(
//                   child: Text('An error has occurred!'),
//                 );
//               } else if (snapshot.hasData) {
//                 return PhotosList(photos: snapshot.data!);
//               } else {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//             },
//           ),
//         ),
//       ]),
//     );
//   }
// }

// class PhotosList extends StatelessWidget {
//   const PhotosList({super.key, required this.photos});

//   final List<Photo> photos;

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//       ),
//       itemCount: photos.length,
//       itemBuilder: (context, index) {
//         return Image.network(photos[index].thumbnailUrl);
//       },
//     );
//   }
// }


