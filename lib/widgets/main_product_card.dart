import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainProductCard extends StatelessWidget {
  const MainProductCard(
      {Key? key,
      required this.title,
      required this.brandName,
      required this.image,
      required this.price,
      this.priceSale,
      this.salePercent,
      required this.isNew,
      required this.numberReviews,
      required this.reviewStars})
      : super(key: key);
  final String title;
  final String brandName;
  final String image;
  final double price;
  final double? priceSale;
  final double? salePercent;
  final bool isNew;
  final int numberReviews;
  final int reviewStars;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 162,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: AssetImage(image), fit: BoxFit.cover)),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  reviewStars > 0
                      ? const ImageIcon(
                          AssetImage("assets/images/icons/star_fill.png"),
                          color: Color(0xffFFBA49),
                          size: 13,
                        )
                      : const ImageIcon(
                          AssetImage("assets/images/icons/star_fill.png"),
                          color: Color(0xff9B9B9B),
                          size: 13,
                        ),
                  reviewStars > 1
                      ? const ImageIcon(
                          AssetImage("assets/images/icons/star_fill.png"),
                          color: Color(0xffFFBA49),
                          size: 13,
                        )
                      : const ImageIcon(
                          AssetImage("assets/images/icons/star_fill.png"),
                          color: Color(0xff9B9B9B),
                          size: 13,
                        ),
                  reviewStars > 2
                      ? const ImageIcon(
                          AssetImage("assets/images/icons/star_fill.png"),
                          color: Color(0xffFFBA49),
                          size: 13,
                        )
                      : const ImageIcon(
                          AssetImage("assets/images/icons/star_fill.png"),
                          color: Color(0xff9B9B9B),
                          size: 13,
                        ),
                  reviewStars > 3
                      ? const ImageIcon(
                          AssetImage("assets/images/icons/star_fill.png"),
                          color: Color(0xffFFBA49),
                          size: 13,
                        )
                      : const ImageIcon(
                          AssetImage("assets/images/icons/star_fill.png"),
                          color: Color(0xff9B9B9B),
                          size: 13,
                        ),
                  reviewStars > 4
                      ? const ImageIcon(
                          AssetImage("assets/images/icons/star_fill.png"),
                          color: Color(0xffFFBA49),
                          size: 13,
                        )
                      : const ImageIcon(
                          AssetImage("assets/images/icons/star_fill.png"),
                          color: Color(0xff9B9B9B),
                          size: 13,
                        ),
                  Text(
                    "($numberReviews)",
                    style:
                        const TextStyle(color: Color(0xff9B9B9B), fontSize: 13),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                brandName,
                style: const TextStyle(fontSize: 11, color: Color(0xff9B9B9B)),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 5,
              ),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    priceSale != null
                        ? TextSpan(
                            text: '${price.toStringAsFixed(0)}\$',
                            style: const TextStyle(
                              fontFamily: "Metropolis",
                              color: Color(0xff9B9B9B),
                              decoration: TextDecoration.lineThrough,
                            ),
                          )
                        : TextSpan(
                            text: '${price.toStringAsFixed(0)}\$',
                            style: const TextStyle(
                              fontFamily: "Metropolis",
                              color: Color(0xffDB3022),
                            ),
                          ),
                    priceSale != null
                        ? TextSpan(
                            text: ' ${priceSale!.toStringAsFixed(0)}\$',
                            style: const TextStyle(
                              fontFamily: "Metropolis",
                              color: Color(0xffDB3022),
                            ),
                          )
                        : const TextSpan(
                            text: '',
                          ),
                  ],
                ),
              )
            ],
          ),
          salePercent != null
              ? Positioned(
                  top: 5,
                  left: 5,
                  child: Chip(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    backgroundColor: const Color(0xffDB3022),
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    label: Text(
                      '-${salePercent!.toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
                )
              : const SizedBox(),
          isNew
              ? const Positioned(
                  top: 5,
                  left: 5,
                  child: Chip(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    backgroundColor: Color(0xff222222),
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    label: Text(
                      'NEW',
                      style: TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
                )
              : const SizedBox(),
          Positioned(
            top: 180,
            right: 0,
            child: InkWell(
                onTap: () {},
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(
                    CupertinoIcons.heart,
                    color: Color(0xffDADADA),
                    size: 16,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
