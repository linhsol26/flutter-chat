// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Failure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String? msg) $default, {
    required TResult Function() noConnection,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String? msg)? $default, {
    TResult? Function()? noConnection,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String? msg)? $default, {
    TResult Function()? noConnection,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(OnFailure value) $default, {
    required TResult Function(OnNoConnection value) noConnection,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(OnFailure value)? $default, {
    TResult? Function(OnNoConnection value)? noConnection,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(OnFailure value)? $default, {
    TResult Function(OnNoConnection value)? noConnection,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$OnFailureCopyWith<$Res> {
  factory _$$OnFailureCopyWith(
          _$OnFailure value, $Res Function(_$OnFailure) then) =
      __$$OnFailureCopyWithImpl<$Res>;
  @useResult
  $Res call({String? msg});
}

/// @nodoc
class __$$OnFailureCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$OnFailure>
    implements _$$OnFailureCopyWith<$Res> {
  __$$OnFailureCopyWithImpl(
      _$OnFailure _value, $Res Function(_$OnFailure) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? msg = freezed,
  }) {
    return _then(_$OnFailure(
      msg: freezed == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OnFailure extends OnFailure {
  const _$OnFailure({this.msg}) : super._();

  @override
  final String? msg;

  @override
  String toString() {
    return 'Failure(msg: $msg)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnFailure &&
            (identical(other.msg, msg) || other.msg == msg));
  }

  @override
  int get hashCode => Object.hash(runtimeType, msg);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnFailureCopyWith<_$OnFailure> get copyWith =>
      __$$OnFailureCopyWithImpl<_$OnFailure>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String? msg) $default, {
    required TResult Function() noConnection,
  }) {
    return $default(msg);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String? msg)? $default, {
    TResult? Function()? noConnection,
  }) {
    return $default?.call(msg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String? msg)? $default, {
    TResult Function()? noConnection,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(msg);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(OnFailure value) $default, {
    required TResult Function(OnNoConnection value) noConnection,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(OnFailure value)? $default, {
    TResult? Function(OnNoConnection value)? noConnection,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(OnFailure value)? $default, {
    TResult Function(OnNoConnection value)? noConnection,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class OnFailure extends Failure {
  const factory OnFailure({final String? msg}) = _$OnFailure;
  const OnFailure._() : super._();

  String? get msg;
  @JsonKey(ignore: true)
  _$$OnFailureCopyWith<_$OnFailure> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnNoConnectionCopyWith<$Res> {
  factory _$$OnNoConnectionCopyWith(
          _$OnNoConnection value, $Res Function(_$OnNoConnection) then) =
      __$$OnNoConnectionCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OnNoConnectionCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$OnNoConnection>
    implements _$$OnNoConnectionCopyWith<$Res> {
  __$$OnNoConnectionCopyWithImpl(
      _$OnNoConnection _value, $Res Function(_$OnNoConnection) _then)
      : super(_value, _then);
}

/// @nodoc

class _$OnNoConnection extends OnNoConnection {
  const _$OnNoConnection() : super._();

  @override
  String toString() {
    return 'Failure.noConnection()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OnNoConnection);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String? msg) $default, {
    required TResult Function() noConnection,
  }) {
    return noConnection();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String? msg)? $default, {
    TResult? Function()? noConnection,
  }) {
    return noConnection?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String? msg)? $default, {
    TResult Function()? noConnection,
    required TResult orElse(),
  }) {
    if (noConnection != null) {
      return noConnection();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(OnFailure value) $default, {
    required TResult Function(OnNoConnection value) noConnection,
  }) {
    return noConnection(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(OnFailure value)? $default, {
    TResult? Function(OnNoConnection value)? noConnection,
  }) {
    return noConnection?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(OnFailure value)? $default, {
    TResult Function(OnNoConnection value)? noConnection,
    required TResult orElse(),
  }) {
    if (noConnection != null) {
      return noConnection(this);
    }
    return orElse();
  }
}

abstract class OnNoConnection extends Failure {
  const factory OnNoConnection() = _$OnNoConnection;
  const OnNoConnection._() : super._();
}
