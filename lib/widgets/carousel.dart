import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class CarouselWidget extends StatelessWidget {
  CarouselWidget({Key? key}) : super(key: key);

  final imgList = <String, String>{
    "Street clothes": 'assets/images/carousel1.jpg',
    "Sleep clothes": 'assets/images/carousel2.jpg',
    "Sport clothes": 'assets/images/carousel3.jpg',
    "Inform clothes": 'assets/images/carousel4.jpg',
  };

  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList.entries
        .map((entry) => InkWell(
            onTap: () {},
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: Image.asset(entry.value, fit: BoxFit.cover),
                ),
                Positioned(
                    bottom: 20,
                    left: 15,
                    child: Text(
                      entry.key,
                      style: ETextStyle.metropolis(
                          color: Colors.white,
                          fontSize: 34,
                          weight: FontWeight.w800),
                    ))
              ],
            )))
        .toList();

    return CarouselSlider(
      items: imageSliders,
      carouselController: _controller,
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 2.0,
        viewportFraction: 1,
      ),
    );
  }
}
