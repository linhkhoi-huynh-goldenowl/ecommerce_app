part of 'tag_cubit.dart';

enum TagStatus { initial, loading, success, failure }

// ignore: must_be_immutable
class TagState extends Equatable {
  TagState(
      {this.status = TagStatus.initial,
      this.tags = const [],
      this.tagsForFilter = const [],
      this.errMessage = ""});
  final TagStatus status;
  final List<TagModel> tags;

  List<TagModel> tagsForFilter;
  final String errMessage;

  TagState copyWith(
      {TagStatus? status,
      List<TagModel>? tags,
      List<TagModel>? tagsForFilter,
      String? errMessage}) {
    return TagState(
        tags: tags ?? this.tags,
        tagsForFilter: tagsForFilter ?? this.tagsForFilter,
        status: status ?? this.status,
        errMessage: errMessage ?? this.errMessage);
  }

  @override
  List<Object> get props => [status, tags, tagsForFilter, errMessage];
}
