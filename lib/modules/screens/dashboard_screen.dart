import 'package:ecommerce_app/widgets/carousel.dart';
import 'package:ecommerce_app/widgets/home_label_widget.dart';
import 'package:ecommerce_app/widgets/main_product_card.dart';
import 'package:flutter/material.dart';

//TODO: sửa DashboardScreen => HomeScreen
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        const CarouselWidget(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            children: [
              HomeLabelWidget(
                  title: "Sale",
                  subTitle: "Super summer sale",
                  func: () {
                    Navigator.of(context).pushNamed("/SaleProductScreen");
                  }),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    MainProductCard(
                        title: "T-Shirt Sailing",
                        brandName: "Dirty Coins",
                        image: "assets/images/sale_product1.png",
                        price: 25,
                        isNew: false,
                        priceSale: 18,
                        salePercent: 20,
                        numberReviews: 10,
                        reviewStars: 4),
                    MainProductCard(
                        title: "Long Pain",
                        brandName: "SWE",
                        image: "assets/images/sale_product2.png",
                        price: 40,
                        isNew: false,
                        priceSale: 21,
                        salePercent: 30,
                        numberReviews: 3,
                        reviewStars: 2),
                    MainProductCard(
                        title: "Dress Spring",
                        brandName: "Adidas",
                        image: "assets/images/sale_product3.png",
                        price: 60,
                        isNew: false,
                        priceSale: 54,
                        salePercent: 30,
                        numberReviews: 33,
                        reviewStars: 5),
                  ],
                ),
              ),
              HomeLabelWidget(
                  title: "New",
                  subTitle: "You've never seen it before!",
                  func: () {
                    Navigator.of(context).pushNamed("/NewProductScreen");
                  }),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    MainProductCard(
                        title: "T-Shirt Sailing",
                        brandName: "Dirty Coins",
                        image: "assets/images/sale_product3.png",
                        price: 25,
                        isNew: true,
                        numberReviews: 10,
                        reviewStars: 4),
                    MainProductCard(
                        title: "Long Pain",
                        brandName: "SWE",
                        image: "assets/images/sale_product2.png",
                        price: 40,
                        isNew: true,
                        numberReviews: 3,
                        reviewStars: 2),
                    MainProductCard(
                        title: "Dress Spring",
                        brandName: "Adidas",
                        image: "assets/images/sale_product1.png",
                        price: 60,
                        isNew: true,
                        numberReviews: 33,
                        reviewStars: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
