import 'package:e_commerce_shop_app/config/routes/router.dart';
import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/dialogs/system_dialog.dart';
import 'package:e_commerce_shop_app/modules/cubit/address/address_cubit.dart';
import 'package:e_commerce_shop_app/modules/models/address.dart';
import 'package:e_commerce_shop_app/utils/helpers/show_snackbar.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_leading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/loading_widget.dart';

class ShippingAddressScreen extends StatelessWidget {
  const ShippingAddressScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddressCubit>(
        create: (BuildContext context) => AddressCubit(),
        child: BlocListener<AddressCubit, AddressState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == AddressStatus.failure) {
                AppSnackBar.showSnackBar(context, state.errMessage);
              }
            },
            child: Scaffold(
                appBar: _appBar(),
                floatingActionButton: _addButton(),
                body: _showAddressList())));
  }

  Widget _showAddressList() {
    return BlocBuilder<AddressCubit, AddressState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == AddressStatus.loading
            ? const LoadingWidget()
            : (state.addresses.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    itemBuilder: (context, index) {
                      return BlocBuilder<AddressCubit, AddressState>(
                          buildWhen: (previous, current) =>
                              previous.defaultStatus != current.defaultStatus,
                          builder: (context, stateDefault) {
                            return _addressCard(stateDefault.addresses[index],
                                () {
                              SystemDialog.showConfirmDialog(
                                  context: context,
                                  func: () {
                                    context.read<AddressCubit>().removeAddress(
                                        stateDefault.addresses[index]);
                                  },
                                  title: "Are you sure",
                                  content: "Do you want to delete?");
                            }, () {
                              context.read<AddressCubit>().loadInfoAddressForm(
                                  stateDefault.addresses[index]);
                              Navigator.of(context).pushNamed(
                                  Routes.addAddressScreen,
                                  arguments: {
                                    'addressId':
                                        stateDefault.addresses[index].id,
                                    'context': context
                                  });
                            }, () {
                              context.read<AddressCubit>().setDefaultAddress(
                                  stateDefault.addresses[index]);
                            });
                          });
                    },
                    itemCount: state.addresses.length,
                  )
                : Center(
                    child: Text("Please Add Shipping Address",
                        style: ETextStyle.metropolis(fontSize: 22)),
                  ));
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
        backgroundColor: const Color(0xffF9F9F9),
        centerTitle: true,
        leading: const ButtonLeading(),
        title: Text(
          "Shipping Address",
          style: ETextStyle.metropolis(weight: FontWeight.w600, fontSize: 20),
        ));
  }
}

Widget _addButton() {
  return BlocBuilder<AddressCubit, AddressState>(
    buildWhen: (previous, current) => previous.status != current.status,
    builder: (context, state) {
      return SizedBox(
        width: 50,
        child: RawMaterialButton(
          fillColor: Colors.black,
          onPressed: () {
            context.read<AddressCubit>().resetAddressForm();
            Navigator.of(context).pushNamed(Routes.addAddressScreen,
                arguments: {'context': context});
          },
          elevation: 5,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(10),
          shape: const CircleBorder(),
        ),
      );
    },
  );
}

Widget _addressCard(Address address, VoidCallback removeAddress,
    VoidCallback editAddress, VoidCallback changeDefault) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Stack(
      children: [
        Container(
          width: double.maxFinite,
          padding:
              const EdgeInsets.only(top: 18, left: 28, right: 23, bottom: 18),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.fullName,
                style: ETextStyle.metropolis(
                    fontSize: 14, weight: FontWeight.w600),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                address.address,
                style: ETextStyle.metropolis(fontSize: 14),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "${address.city}, ${address.region} ${address.zipCode}, ${address.country}",
                style: ETextStyle.metropolis(fontSize: 14),
              ),
              _checkUseShipping(changeDefault, address.isDefault)
            ],
          ),
        ),
        Positioned(
            top: 0,
            right: 0,
            child: TextButton(
              onPressed: editAddress,
              child: Text(
                "Edit",
                style: ETextStyle.metropolis(
                    color: const Color(0xffDB3022),
                    fontSize: 14,
                    weight: FontWeight.w600),
              ),
            )),
        Positioned(
            top: 35,
            right: 4,
            child: IconButton(
              splashRadius: 15,
              onPressed: removeAddress,
              icon: const ImageIcon(
                  AssetImage("assets/images/icons/delete.png"),
                  size: 14),
            )),
      ],
    ),
  );
}

Widget _checkUseShipping(VoidCallback func, bool check) {
  return Row(
    children: [
      Transform.scale(
        scale: 1.4,
        child: SizedBox(
          width: 24,
          child: Checkbox(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.5)),
            activeColor: Colors.black,
            checkColor: Colors.white,
            value: check,
            onChanged: (_) {
              func();
            },
          ),
        ),
      ),
      const SizedBox(
        width: 14,
      ),
      Text(
        "Use as the shipping address",
        style: ETextStyle.metropolis(fontSize: 14),
      )
    ],
  );
}
