import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../config/routes/router.dart';

class CarouselProductWidget extends StatelessWidget {
  CarouselProductWidget({Key? key, required this.imgList}) : super(key: key);

  final List<String> imgList;

  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: imgList
          .map((entry) => InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(Routes.photoViewScreen, arguments: {
                    'paths': imgList,
                    'index': imgList.indexWhere((element) => element == entry)
                  });
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(entry, fit: BoxFit.fitHeight),
                ),
              ))
          .toList(),
      carouselController: _controller,
      options: CarouselOptions(
        height: 413,
        autoPlay: true,
        aspectRatio: 2.0,
        viewportFraction: 1,
      ),
    );
  }
}
