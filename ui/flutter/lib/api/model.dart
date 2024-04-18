import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class GetCounterResult {
  final int count;

  GetCounterResult(this.count);

  factory GetCounterResult.fromJson(Map<String, dynamic> json) => _$GetCounterResultFromJson(json);

  Map<String, dynamic> toJson() => _$GetCounterResultToJson(this);
}

@JsonSerializable()
class GetStatusResult {
  final String status;

  GetStatusResult(this.status);

  factory GetStatusResult.fromJson(Map<String, dynamic> json) => _$GetStatusResultFromJson(json);

  Map<String, dynamic> toJson() => _$GetStatusResultToJson(this);
}
