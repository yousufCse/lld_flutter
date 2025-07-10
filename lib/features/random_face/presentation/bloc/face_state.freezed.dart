// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'face_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FaceState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FaceState()';
}


}

/// @nodoc
class $FaceStateCopyWith<$Res>  {
$FaceStateCopyWith(FaceState _, $Res Function(FaceState) __);
}


/// Adds pattern-matching-related methods to [FaceState].
extension FaceStatePatterns on FaceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FaceInitial value)?  initial,TResult Function( FaceLoading value)?  loading,TResult Function( FaceLoaded value)?  loaded,TResult Function( FaceError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FaceInitial() when initial != null:
return initial(_that);case FaceLoading() when loading != null:
return loading(_that);case FaceLoaded() when loaded != null:
return loaded(_that);case FaceError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FaceInitial value)  initial,required TResult Function( FaceLoading value)  loading,required TResult Function( FaceLoaded value)  loaded,required TResult Function( FaceError value)  error,}){
final _that = this;
switch (_that) {
case FaceInitial():
return initial(_that);case FaceLoading():
return loading(_that);case FaceLoaded():
return loaded(_that);case FaceError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FaceInitial value)?  initial,TResult? Function( FaceLoading value)?  loading,TResult? Function( FaceLoaded value)?  loaded,TResult? Function( FaceError value)?  error,}){
final _that = this;
switch (_that) {
case FaceInitial() when initial != null:
return initial(_that);case FaceLoading() when loading != null:
return loading(_that);case FaceLoaded() when loaded != null:
return loaded(_that);case FaceError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Face face)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FaceInitial() when initial != null:
return initial();case FaceLoading() when loading != null:
return loading();case FaceLoaded() when loaded != null:
return loaded(_that.face);case FaceError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Face face)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case FaceInitial():
return initial();case FaceLoading():
return loading();case FaceLoaded():
return loaded(_that.face);case FaceError():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Face face)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case FaceInitial() when initial != null:
return initial();case FaceLoading() when loading != null:
return loading();case FaceLoaded() when loaded != null:
return loaded(_that.face);case FaceError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class FaceInitial extends FaceState {
  const FaceInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FaceState.initial()';
}


}




/// @nodoc


class FaceLoading extends FaceState {
  const FaceLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FaceState.loading()';
}


}




/// @nodoc


class FaceLoaded extends FaceState {
  const FaceLoaded({required this.face}): super._();
  

 final  Face face;

/// Create a copy of FaceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaceLoadedCopyWith<FaceLoaded> get copyWith => _$FaceLoadedCopyWithImpl<FaceLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceLoaded&&(identical(other.face, face) || other.face == face));
}


@override
int get hashCode => Object.hash(runtimeType,face);

@override
String toString() {
  return 'FaceState.loaded(face: $face)';
}


}

/// @nodoc
abstract mixin class $FaceLoadedCopyWith<$Res> implements $FaceStateCopyWith<$Res> {
  factory $FaceLoadedCopyWith(FaceLoaded value, $Res Function(FaceLoaded) _then) = _$FaceLoadedCopyWithImpl;
@useResult
$Res call({
 Face face
});




}
/// @nodoc
class _$FaceLoadedCopyWithImpl<$Res>
    implements $FaceLoadedCopyWith<$Res> {
  _$FaceLoadedCopyWithImpl(this._self, this._then);

  final FaceLoaded _self;
  final $Res Function(FaceLoaded) _then;

/// Create a copy of FaceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? face = null,}) {
  return _then(FaceLoaded(
face: null == face ? _self.face : face // ignore: cast_nullable_to_non_nullable
as Face,
  ));
}


}

/// @nodoc


class FaceError extends FaceState {
  const FaceError({required this.failure}): super._();
  

 final  Failure failure;

/// Create a copy of FaceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaceErrorCopyWith<FaceError> get copyWith => _$FaceErrorCopyWithImpl<FaceError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'FaceState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $FaceErrorCopyWith<$Res> implements $FaceStateCopyWith<$Res> {
  factory $FaceErrorCopyWith(FaceError value, $Res Function(FaceError) _then) = _$FaceErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$FaceErrorCopyWithImpl<$Res>
    implements $FaceErrorCopyWith<$Res> {
  _$FaceErrorCopyWithImpl(this._self, this._then);

  final FaceError _self;
  final $Res Function(FaceError) _then;

/// Create a copy of FaceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(FaceError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
