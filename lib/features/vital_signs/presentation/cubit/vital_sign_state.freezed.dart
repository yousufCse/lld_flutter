// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vital_sign_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VitalSignState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VitalSignState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VitalSignState()';
}


}

/// @nodoc
class $VitalSignStateCopyWith<$Res>  {
$VitalSignStateCopyWith(VitalSignState _, $Res Function(VitalSignState) __);
}


/// Adds pattern-matching-related methods to [VitalSignState].
extension VitalSignStatePatterns on VitalSignState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( VitalSignInitial value)?  initial,TResult Function( VitalSignLoading value)?  loading,TResult Function( VitalSignLoaded value)?  loaded,TResult Function( VitalSignError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case VitalSignInitial() when initial != null:
return initial(_that);case VitalSignLoading() when loading != null:
return loading(_that);case VitalSignLoaded() when loaded != null:
return loaded(_that);case VitalSignError() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( VitalSignInitial value)  initial,required TResult Function( VitalSignLoading value)  loading,required TResult Function( VitalSignLoaded value)  loaded,required TResult Function( VitalSignError value)  error,}){
final _that = this;
switch (_that) {
case VitalSignInitial():
return initial(_that);case VitalSignLoading():
return loading(_that);case VitalSignLoaded():
return loaded(_that);case VitalSignError():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( VitalSignInitial value)?  initial,TResult? Function( VitalSignLoading value)?  loading,TResult? Function( VitalSignLoaded value)?  loaded,TResult? Function( VitalSignError value)?  error,}){
final _that = this;
switch (_that) {
case VitalSignInitial() when initial != null:
return initial(_that);case VitalSignLoading() when loading != null:
return loading(_that);case VitalSignLoaded() when loaded != null:
return loaded(_that);case VitalSignError() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( VitalSign vitalSign)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case VitalSignInitial() when initial != null:
return initial();case VitalSignLoading() when loading != null:
return loading();case VitalSignLoaded() when loaded != null:
return loaded(_that.vitalSign);case VitalSignError() when error != null:
return error(_that.failure);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( VitalSign vitalSign)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case VitalSignInitial():
return initial();case VitalSignLoading():
return loading();case VitalSignLoaded():
return loaded(_that.vitalSign);case VitalSignError():
return error(_that.failure);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( VitalSign vitalSign)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case VitalSignInitial() when initial != null:
return initial();case VitalSignLoading() when loading != null:
return loading();case VitalSignLoaded() when loaded != null:
return loaded(_that.vitalSign);case VitalSignError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class VitalSignInitial implements VitalSignState {
  const VitalSignInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VitalSignInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VitalSignState.initial()';
}


}




/// @nodoc


class VitalSignLoading implements VitalSignState {
  const VitalSignLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VitalSignLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VitalSignState.loading()';
}


}




/// @nodoc


class VitalSignLoaded implements VitalSignState {
  const VitalSignLoaded({required this.vitalSign});
  

 final  VitalSign vitalSign;

/// Create a copy of VitalSignState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VitalSignLoadedCopyWith<VitalSignLoaded> get copyWith => _$VitalSignLoadedCopyWithImpl<VitalSignLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VitalSignLoaded&&(identical(other.vitalSign, vitalSign) || other.vitalSign == vitalSign));
}


@override
int get hashCode => Object.hash(runtimeType,vitalSign);

@override
String toString() {
  return 'VitalSignState.loaded(vitalSign: $vitalSign)';
}


}

/// @nodoc
abstract mixin class $VitalSignLoadedCopyWith<$Res> implements $VitalSignStateCopyWith<$Res> {
  factory $VitalSignLoadedCopyWith(VitalSignLoaded value, $Res Function(VitalSignLoaded) _then) = _$VitalSignLoadedCopyWithImpl;
@useResult
$Res call({
 VitalSign vitalSign
});




}
/// @nodoc
class _$VitalSignLoadedCopyWithImpl<$Res>
    implements $VitalSignLoadedCopyWith<$Res> {
  _$VitalSignLoadedCopyWithImpl(this._self, this._then);

  final VitalSignLoaded _self;
  final $Res Function(VitalSignLoaded) _then;

/// Create a copy of VitalSignState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? vitalSign = null,}) {
  return _then(VitalSignLoaded(
vitalSign: null == vitalSign ? _self.vitalSign : vitalSign // ignore: cast_nullable_to_non_nullable
as VitalSign,
  ));
}


}

/// @nodoc


class VitalSignError implements VitalSignState {
  const VitalSignError({required this.failure});
  

 final  Failure failure;

/// Create a copy of VitalSignState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VitalSignErrorCopyWith<VitalSignError> get copyWith => _$VitalSignErrorCopyWithImpl<VitalSignError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VitalSignError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'VitalSignState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $VitalSignErrorCopyWith<$Res> implements $VitalSignStateCopyWith<$Res> {
  factory $VitalSignErrorCopyWith(VitalSignError value, $Res Function(VitalSignError) _then) = _$VitalSignErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$VitalSignErrorCopyWithImpl<$Res>
    implements $VitalSignErrorCopyWith<$Res> {
  _$VitalSignErrorCopyWithImpl(this._self, this._then);

  final VitalSignError _self;
  final $Res Function(VitalSignError) _then;

/// Create a copy of VitalSignState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(VitalSignError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
