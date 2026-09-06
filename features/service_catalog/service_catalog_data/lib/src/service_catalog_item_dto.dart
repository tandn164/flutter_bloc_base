import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:service_catalog_domain/service_catalog_domain.dart';

part 'service_catalog_item_dto.freezed.dart';
part 'service_catalog_item_dto.g.dart';

@freezed
abstract class ServiceCatalogItemDto with _$ServiceCatalogItemDto {
  const ServiceCatalogItemDto._();
  const factory ServiceCatalogItemDto(
      {required String id, required String title}) = _ServiceCatalogItemDto;
  factory ServiceCatalogItemDto.fromJson(Map<String, dynamic> json) =>
      _$ServiceCatalogItemDtoFromJson(json);
  ServiceCatalogItem toEntity() => ServiceCatalogItem(id: id, title: title);
}
