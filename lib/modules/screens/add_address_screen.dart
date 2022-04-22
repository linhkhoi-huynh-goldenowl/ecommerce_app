import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/dialogs/bottom_sheet_app.dart';
import 'package:e_commerce_shop_app/modules/cubit/address/address_cubit.dart';
import 'package:e_commerce_shop_app/modules/models/address.dart';
import 'package:e_commerce_shop_app/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/button_intro.dart';

class AddAddressScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  AddAddressScreen({Key? key, required this.contextParent, this.addressId})
      : super(key: key);
  final String? addressId;
  final BuildContext contextParent;
  final FocusNode focusAddress = FocusNode();
  final FocusNode focusCity = FocusNode();
  final FocusNode focusRegion = FocusNode();
  final FocusNode focusZipCode = FocusNode();
  final FocusNode focusCountry = FocusNode();
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<AddressCubit>(contextParent),
      child: BlocConsumer<AddressCubit, AddressState>(
          listenWhen: (previous, current) =>
              previous.typeStatus != current.typeStatus,
          listener: (context, state) {
            if (state.typeStatus == AddressTypeStatus.submitted) {
              Navigator.of(context).pop();
            }
          },
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            return Scaffold(
              bottomNavigationBar: BottomAppBar(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BlocBuilder<AddressCubit, AddressState>(
                      buildWhen: (previous, current) =>
                          previous.typeStatus != current.typeStatus,
                      builder: (context, state) {
                        return state.typeStatus == AddressTypeStatus.submitting
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ButtonIntro(
                                func: () async {
                                  if (_formKey.currentState!.validate()) {
                                    addressId != null
                                        ? context
                                            .read<AddressCubit>()
                                            .editAddress(Address(
                                                id: addressId,
                                                fullName: state.fullName,
                                                address: state.address,
                                                city: state.city,
                                                region: state.region,
                                                zipCode: state.zipCode,
                                                country: state.country,
                                                isDefault: state.isDefault))
                                        : context
                                            .read<AddressCubit>()
                                            .addAddress(Address(
                                                fullName: state.fullName,
                                                address: state.address,
                                                city: state.city,
                                                region: state.region,
                                                zipCode: state.zipCode,
                                                country: state.country,
                                                isDefault: false));

                                    _formKey.currentState!.reset();
                                  }
                                },
                                title: 'SAVE ADDRESS');
                      }),
                ),
              ),
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  addressId != null
                      ? "Edit Shipping Address"
                      : "Adding Shipping Address",
                  style: ETextStyle.metropolis(
                      weight: FontWeight.w600, fontSize: 19),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 2,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
              ),
              body: _addressForm(context),
            );
          }),
    );
  }

  Widget _addressForm(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      buildWhen: (previous, current) =>
          previous.typeStatus != current.typeStatus,
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              TextFieldWidget(
                initValue: state.fullName,
                onEditComplete: () =>
                    FocusScope.of(context).requestFocus(focusAddress),
                labelText: 'Full Name',
                validatorText: 'Full Name must more than 1',
                isValid: state.isFullNameValid,
                func: (value) =>
                    context.read<AddressCubit>().fullNameChanged(value),
                isPassword: false,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                initValue: state.address,
                focusNode: focusAddress,
                onEditComplete: () =>
                    FocusScope.of(context).requestFocus(focusCity),
                labelText: 'Address',
                validatorText: 'Address must more than 5',
                isValid: state.isAddressValid,
                func: (value) =>
                    context.read<AddressCubit>().addressChanged(value),
                isPassword: false,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                initValue: state.city,
                focusNode: focusCity,
                onEditComplete: () =>
                    FocusScope.of(context).requestFocus(focusRegion),
                labelText: 'City',
                validatorText: 'City must more than 2',
                isValid: state.isCityValid,
                func: (value) =>
                    context.read<AddressCubit>().cityChanged(value),
                isPassword: false,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                initValue: state.region,
                focusNode: focusRegion,
                onEditComplete: () =>
                    FocusScope.of(context).requestFocus(focusZipCode),
                labelText: 'State/Province/Region',
                validatorText: 'Region must more than 5',
                isValid: state.isRegionValid,
                func: (value) =>
                    context.read<AddressCubit>().regionChanged(value),
                isPassword: false,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                initValue: state.zipCode,
                inputType: TextInputType.number,
                focusNode: focusZipCode,
                onEditComplete: () =>
                    FocusScope.of(context).requestFocus(focusCountry),
                labelText: 'Zip Code (Postal Code)',
                validatorText: 'Zip Code must more than 4',
                isValid: state.isZipCodeValid,
                func: (value) =>
                    context.read<AddressCubit>().zipCodeChanged(value),
                isPassword: false,
              ),
              const SizedBox(
                height: 20,
              ),
              _countryTextField(() {
                BottomSheetApp.showModelCountries(context);
              }, focusCountry, state.country, state.isCountryValid),
            ],
          ),
        );
      },
    );
  }
}

Widget _countryTextField(
    VoidCallback onTap, FocusNode focusNode, String initValue, bool isValid) {
  return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: TextFormField(
        key: ValueKey(initValue),
        readOnly: true,
        onTap: onTap,
        focusNode: focusNode,
        initialValue: initValue,
        decoration: InputDecoration(
          suffixIcon: const Icon(
            Icons.chevron_right,
            color: Colors.black,
          ),
          border: InputBorder.none,
          labelStyle: ETextStyle.metropolis(color: const Color(0xffbcbcbc)),
          floatingLabelStyle:
              ETextStyle.metropolis(color: const Color(0xffbcbcbc)),
          labelText: "Country",
          fillColor: const Color(0xffbcbcbc),
          hoverColor: const Color(0xffbcbcbc),
          focusColor: const Color(0xffbcbcbc),
        ),
        validator: (value) => isValid ? null : "Please choose country",
      ));
}
