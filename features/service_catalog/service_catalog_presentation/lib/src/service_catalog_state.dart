import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:service_catalog_domain/service_catalog_domain.dart';

part 'service_catalog_state.freezed.dart';

@freezed
sealed class ServiceCatalogState with _$ServiceCatalogState {
  const factory ServiceCatalogState.loading() = ServiceCatalogLoading;
  const factory ServiceCatalogState.data(List<ServiceCatalogItem> items) =
      ServiceCatalogData;
  const factory ServiceCatalogState.error(String message) = ServiceCatalogError;
}
