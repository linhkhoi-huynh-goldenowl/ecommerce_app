import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/cubit/tag/tag_cubit.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopupTag extends StatelessWidget {
  const PopupTag({Key? key, required this.applyTag}) : super(key: key);
  final Function applyTag;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: 0.7,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: BottomAppBar(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocBuilder<TagCubit, TagState>(
                    buildWhen: (previous, current) =>
                        previous.tagsForFilter != current.tagsForFilter,
                    builder: (context, stateTag) {
                      return ButtonIntro(
                          func: () {
                            applyTag(stateTag.tagsForFilter);
                            Navigator.of(context).pop();
                          },
                          title: "APPLY TAG");
                    })),
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 14,
              ),
              Image.asset(
                "assets/images/icons/rectangle.png",
                scale: 3,
              ),
              const SizedBox(
                height: 16,
              ),
              Center(
                child: Text(
                  "Choose tag to filter",
                  style: ETextStyle.metropolis(
                      fontSize: 18, weight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Expanded(
                  child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                children: [
                  BlocBuilder<TagCubit, TagState>(
                    buildWhen: (previous, current) =>
                        previous.tags != current.tags ||
                        previous.tagsForFilter != current.tagsForFilter,
                    builder: (context, state) {
                      return Wrap(
                          alignment: WrapAlignment.start,
                          runSpacing: 10,
                          spacing: 10,
                          children: state.tags
                              .map((e) => _chipTags(
                                  context
                                      .read<TagCubit>()
                                      .checkContainInList(e),
                                  () {
                                    context
                                        .read<TagCubit>()
                                        .addTagToListFilter(e);
                                  },
                                  e.name,
                                  () {
                                    context
                                        .read<TagCubit>()
                                        .deleteTagToListFilter(e);
                                  }))
                              .toList());
                    },
                  ),
                ],
              ))
            ],
          ),
        ));
  }

  Widget _chipTags(bool isChoose, VoidCallback chooseTag, String name,
      VoidCallback deleteTag) {
    return InputChip(
      label: Text(
        name,
        style: ETextStyle.metropolis(fontSize: 11),
      ),
      elevation: 2,
      selected: isChoose,
      onPressed: chooseTag,
      onDeleted: isChoose ? deleteTag : null,
    );
  }
}
