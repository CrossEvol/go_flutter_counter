import 'package:json_annotation/json_annotation.dart';

part 'start_config.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class StartConfig {

  @JsonKey()
  final String databaseUrl;

  StartConfig({required this.databaseUrl});

  factory StartConfig.fromJson(Map<String, dynamic> json) =>
      _$StartConfigFromJson(json);

  Map<String, dynamic> toJson() => _$StartConfigToJson(this);
}
