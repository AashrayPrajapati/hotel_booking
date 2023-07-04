import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

List imgList = [
  {"id": 1, "image_path": 'assets/room1.png'},
  {"id": 2, "image_path": 'assets/room2.png'},
  {"id": 3, "image_path": 'assets/room3.png'},
  {"id": 4, "image_path": 'assets/room4.png'},
];
final CarouselController carouselController = CarouselController();
int currentIndex = 0;

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(title: Text('Horizontal sliding carousel')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: CarouselSlider(
              items: imgList
                  .map(
                    (item) => Image.asset(
                      item['image_path'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                  .toList(),
              carouselController: carouselController,
              options: CarouselOptions(
                scrollPhysics: const BouncingScrollPhysics(),
                autoPlay: false,
                aspectRatio: 2,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 7),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => carouselController.animateToPage(entry.key),
                child: Container(
                  width: currentIndex == entry.key ? 23 : 17,
                  height: 13.0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 3.0,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: currentIndex == entry.key
                          ? Color.fromARGB(255, 39, 92, 216)
                          : Color.fromARGB(255, 200, 200, 200)),
                ),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }
}
