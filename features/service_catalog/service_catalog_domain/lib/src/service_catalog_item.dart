import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_catalog_item.freezed.dart';

@freezed
abstract class ServiceCatalogItem with _$ServiceCatalogItem {
  const factory ServiceCatalogItem(
      {required String id, required String title}) = _ServiceCatalogItem;
}
