// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_reply.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MessageReply _$MessageReplyFromJson(Map<String, dynamic> json) {
  return _MessageReply.fromJson(json);
}

/// @nodoc
mixin _$MessageReply {
  String get message => throw _privateConstructorUsedError;
  bool get isMe => throw _privateConstructorUsedError;
  MessageType get messageType => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageReplyCopyWith<MessageReply> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageReplyCopyWith<$Res> {
  factory $MessageReplyCopyWith(
          MessageReply value, $Res Function(MessageReply) then) =
      _$MessageReplyCopyWithImpl<$Res, MessageReply>;
  @useResult
  $Res call(
      {String message, bool isMe, MessageType messageType, String username});
}

/// @nodoc
class _$MessageReplyCopyWithImpl<$Res, $Val extends MessageReply>
    implements $MessageReplyCopyWith<$Res> {
  _$MessageReplyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? isMe = null,
    Object? messageType = null,
    Object? username = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isMe: null == isMe
          ? _value.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as MessageType,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MessageReplyCopyWith<$Res>
    implements $MessageReplyCopyWith<$Res> {
  factory _$$_MessageReplyCopyWith(
          _$_MessageReply value, $Res Function(_$_MessageReply) then) =
      __$$_MessageReplyCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message, bool isMe, MessageType messageType, String username});
}

/// @nodoc
class __$$_MessageReplyCopyWithImpl<$Res>
    extends _$MessageReplyCopyWithImpl<$Res, _$_MessageReply>
    implements _$$_MessageReplyCopyWith<$Res> {
  __$$_MessageReplyCopyWithImpl(
      _$_MessageReply _value, $Res Function(_$_MessageReply) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? isMe = null,
    Object? messageType = null,
    Object? username = null,
  }) {
    return _then(_$_MessageReply(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isMe: null == isMe
          ? _value.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as MessageType,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MessageReply extends _MessageReply {
  const _$_MessageReply(
      {required this.message,
      required this.isMe,
      required this.messageType,
      required this.username})
      : super._();

  factory _$_MessageReply.fromJson(Map<String, dynamic> json) =>
      _$$_MessageReplyFromJson(json);

  @override
  final String message;
  @override
  final bool isMe;
  @override
  final MessageType messageType;
  @override
  final String username;

  @override
  String toString() {
    return 'MessageReply(message: $message, isMe: $isMe, messageType: $messageType, username: $username)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MessageReply &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isMe, isMe) || other.isMe == isMe) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, message, isMe, messageType, username);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MessageReplyCopyWith<_$_MessageReply> get copyWith =>
      __$$_MessageReplyCopyWithImpl<_$_MessageReply>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MessageReplyToJson(
      this,
    );
  }
}

abstract class _MessageReply extends MessageReply {
  const factory _MessageReply(
      {required final String message,
      required final bool isMe,
      required final MessageType messageType,
      required final String username}) = _$_MessageReply;
  const _MessageReply._() : super._();

  factory _MessageReply.fromJson(Map<String, dynamic> json) =
      _$_MessageReply.fromJson;

  @override
  String get message;
  @override
  bool get isMe;
  @override
  MessageType get messageType;
  @override
  String get username;
  @override
  @JsonKey(ignore: true)
  _$$_MessageReplyCopyWith<_$_MessageReply> get copyWith =>
      throw _privateConstructorUsedError;
}
