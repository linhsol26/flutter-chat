// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

StatusModel _$StatusModelFromJson(Map<String, dynamic> json) {
  return _StatusModel.fromJson(json);
}

/// @nodoc
mixin _$StatusModel {
  String get uid => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  List<String> get photoUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get profilePic => throw _privateConstructorUsedError;
  String get statusId => throw _privateConstructorUsedError;
  List<String> get whoCanSee => throw _privateConstructorUsedError;
  List<String> get isSeen => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StatusModelCopyWith<StatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatusModelCopyWith<$Res> {
  factory $StatusModelCopyWith(
          StatusModel value, $Res Function(StatusModel) then) =
      _$StatusModelCopyWithImpl<$Res, StatusModel>;
  @useResult
  $Res call(
      {String uid,
      String username,
      String phoneNumber,
      List<String> photoUrl,
      DateTime createdAt,
      String profilePic,
      String statusId,
      List<String> whoCanSee,
      List<String> isSeen});
}

/// @nodoc
class _$StatusModelCopyWithImpl<$Res, $Val extends StatusModel>
    implements $StatusModelCopyWith<$Res> {
  _$StatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? username = null,
    Object? phoneNumber = null,
    Object? photoUrl = null,
    Object? createdAt = null,
    Object? profilePic = null,
    Object? statusId = null,
    Object? whoCanSee = null,
    Object? isSeen = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: null == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profilePic: null == profilePic
          ? _value.profilePic
          : profilePic // ignore: cast_nullable_to_non_nullable
              as String,
      statusId: null == statusId
          ? _value.statusId
          : statusId // ignore: cast_nullable_to_non_nullable
              as String,
      whoCanSee: null == whoCanSee
          ? _value.whoCanSee
          : whoCanSee // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isSeen: null == isSeen
          ? _value.isSeen
          : isSeen // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_StatusModelCopyWith<$Res>
    implements $StatusModelCopyWith<$Res> {
  factory _$$_StatusModelCopyWith(
          _$_StatusModel value, $Res Function(_$_StatusModel) then) =
      __$$_StatusModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String username,
      String phoneNumber,
      List<String> photoUrl,
      DateTime createdAt,
      String profilePic,
      String statusId,
      List<String> whoCanSee,
      List<String> isSeen});
}

/// @nodoc
class __$$_StatusModelCopyWithImpl<$Res>
    extends _$StatusModelCopyWithImpl<$Res, _$_StatusModel>
    implements _$$_StatusModelCopyWith<$Res> {
  __$$_StatusModelCopyWithImpl(
      _$_StatusModel _value, $Res Function(_$_StatusModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? username = null,
    Object? phoneNumber = null,
    Object? photoUrl = null,
    Object? createdAt = null,
    Object? profilePic = null,
    Object? statusId = null,
    Object? whoCanSee = null,
    Object? isSeen = null,
  }) {
    return _then(_$_StatusModel(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: null == photoUrl
          ? _value._photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profilePic: null == profilePic
          ? _value.profilePic
          : profilePic // ignore: cast_nullable_to_non_nullable
              as String,
      statusId: null == statusId
          ? _value.statusId
          : statusId // ignore: cast_nullable_to_non_nullable
              as String,
      whoCanSee: null == whoCanSee
          ? _value._whoCanSee
          : whoCanSee // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isSeen: null == isSeen
          ? _value._isSeen
          : isSeen // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_StatusModel extends _StatusModel {
  const _$_StatusModel(
      {required this.uid,
      required this.username,
      required this.phoneNumber,
      required final List<String> photoUrl,
      required this.createdAt,
      required this.profilePic,
      required this.statusId,
      required final List<String> whoCanSee,
      final List<String> isSeen = const <String>[]})
      : _photoUrl = photoUrl,
        _whoCanSee = whoCanSee,
        _isSeen = isSeen,
        super._();

  factory _$_StatusModel.fromJson(Map<String, dynamic> json) =>
      _$$_StatusModelFromJson(json);

  @override
  final String uid;
  @override
  final String username;
  @override
  final String phoneNumber;
  final List<String> _photoUrl;
  @override
  List<String> get photoUrl {
    if (_photoUrl is EqualUnmodifiableListView) return _photoUrl;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoUrl);
  }

  @override
  final DateTime createdAt;
  @override
  final String profilePic;
  @override
  final String statusId;
  final List<String> _whoCanSee;
  @override
  List<String> get whoCanSee {
    if (_whoCanSee is EqualUnmodifiableListView) return _whoCanSee;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_whoCanSee);
  }

  final List<String> _isSeen;
  @override
  @JsonKey()
  List<String> get isSeen {
    if (_isSeen is EqualUnmodifiableListView) return _isSeen;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_isSeen);
  }

  @override
  String toString() {
    return 'StatusModel(uid: $uid, username: $username, phoneNumber: $phoneNumber, photoUrl: $photoUrl, createdAt: $createdAt, profilePic: $profilePic, statusId: $statusId, whoCanSee: $whoCanSee, isSeen: $isSeen)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StatusModel &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            const DeepCollectionEquality().equals(other._photoUrl, _photoUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.profilePic, profilePic) ||
                other.profilePic == profilePic) &&
            (identical(other.statusId, statusId) ||
                other.statusId == statusId) &&
            const DeepCollectionEquality()
                .equals(other._whoCanSee, _whoCanSee) &&
            const DeepCollectionEquality().equals(other._isSeen, _isSeen));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      username,
      phoneNumber,
      const DeepCollectionEquality().hash(_photoUrl),
      createdAt,
      profilePic,
      statusId,
      const DeepCollectionEquality().hash(_whoCanSee),
      const DeepCollectionEquality().hash(_isSeen));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StatusModelCopyWith<_$_StatusModel> get copyWith =>
      __$$_StatusModelCopyWithImpl<_$_StatusModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_StatusModelToJson(
      this,
    );
  }
}

abstract class _StatusModel extends StatusModel {
  const factory _StatusModel(
      {required final String uid,
      required final String username,
      required final String phoneNumber,
      required final List<String> photoUrl,
      required final DateTime createdAt,
      required final String profilePic,
      required final String statusId,
      required final List<String> whoCanSee,
      final List<String> isSeen}) = _$_StatusModel;
  const _StatusModel._() : super._();

  factory _StatusModel.fromJson(Map<String, dynamic> json) =
      _$_StatusModel.fromJson;

  @override
  String get uid;
  @override
  String get username;
  @override
  String get phoneNumber;
  @override
  List<String> get photoUrl;
  @override
  DateTime get createdAt;
  @override
  String get profilePic;
  @override
  String get statusId;
  @override
  List<String> get whoCanSee;
  @override
  List<String> get isSeen;
  @override
  @JsonKey(ignore: true)
  _$$_StatusModelCopyWith<_$_StatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}
