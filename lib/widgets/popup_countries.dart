import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/constants/countries_name.dart';
import 'package:e_commerce_shop_app/modules/cubit/address/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopupCountries extends StatelessWidget {
  const PopupCountries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FractionallySizedBox(
        heightFactor: 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 14,
            ),
            Center(
              child: Image.asset(
                "assets/images/icons/rectangle.png",
                scale: 3,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Choose your country:",
                  style: ETextStyle.metropolis(weight: FontWeight.w600),
                )),
            Expanded(
              child: BlocBuilder<AddressCubit, AddressState>(
                  builder: (context, state) {
                List<String> countries = CountriesName().countries;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return _countryItem(countries[index], () {
                      context.read<AddressCubit>().setCountry(countries[index]);
                      Navigator.of(context).pop();
                    });
                  },
                  itemCount: countries.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}

Widget _countryItem(String country, VoidCallback func) {
  return InkWell(
    onTap: func,
    child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: Text(
          country,
          textAlign: TextAlign.center,
          style: ETextStyle.metropolis(),
        )),
  );
}
