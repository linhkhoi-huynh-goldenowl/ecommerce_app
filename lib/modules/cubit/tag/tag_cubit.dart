import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/models/tag_model.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/domain.dart';
import '../../repositories/x_result.dart';

part 'tag_state.dart';

class TagCubit extends Cubit<TagState> {
  TagCubit() : super(TagState()) {
    fetchTag();
  }

  StreamSubscription? tagSubscription;
  @override
  Future<void> close() {
    tagSubscription?.cancel();
    return super.close();
  }

  void fetchTag() async {
    try {
      emit(state.copyWith(status: TagStatus.loading));
      final Stream<XResult<List<TagModel>>> tagStream =
          Domain().tag.getTagStream();

      tagSubscription = tagStream.listen((event) async {
        emit(state.copyWith(status: TagStatus.loading));
        if (event.isSuccess) {
          emit(state.copyWith(
              status: TagStatus.success, tags: event.data, errMessage: ""));
        } else {
          emit(state.copyWith(
              status: TagStatus.failure, errMessage: event.error));
        }
      });
    } catch (_) {
      emit(state.copyWith(
          status: TagStatus.failure, errMessage: "Something wrong"));
    }
  }

  void addTagToListFilter(TagModel item) {
    List<TagModel> tagsFilter = [];
    tagsFilter.addAll(state.tagsForFilter);

    tagsFilter.add(item);
    emit(state.copyWith(tagsForFilter: tagsFilter));
  }

  void deleteTagToListFilter(TagModel item) {
    List<TagModel> tagsFilter = [];
    tagsFilter.addAll(state.tagsForFilter);

    tagsFilter.removeWhere((element) => element.name == item.name);
    emit(state.copyWith(tagsForFilter: tagsFilter));
  }

  bool checkContainInList(TagModel item) {
    return state.tagsForFilter
        .where((element) => element.name == item.name)
        .toList()
        .isNotEmpty;
  }
}
