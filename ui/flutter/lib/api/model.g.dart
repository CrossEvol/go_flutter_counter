// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCounterResult _$GetCounterResultFromJson(Map<String, dynamic> json) =>
    GetCounterResult(
      json['count'] as int,
    );

Map<String, dynamic> _$GetCounterResultToJson(GetCounterResult instance) =>
    <String, dynamic>{
      'count': instance.count,
    };

GetStatusResult _$GetStatusResultFromJson(Map<String, dynamic> json) =>
    GetStatusResult(
      json['status'] as String,
    );

Map<String, dynamic> _$GetStatusResultToJson(GetStatusResult instance) =>
    <String, dynamic>{
      'status': instance.status,
    };
