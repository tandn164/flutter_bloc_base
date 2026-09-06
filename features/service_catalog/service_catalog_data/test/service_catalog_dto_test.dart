import 'package:service_catalog_data/service_catalog_data.dart';
import 'package:test/test.dart';

void main() {
  test('DTO JSON round-trip and explicit entity mapping', () {
    const dto = ServiceCatalogItemDto(id: '1', title: 'Sample');
    expect(ServiceCatalogItemDto.fromJson(dto.toJson()), dto);
    expect(dto.toEntity().id, '1');
  });
}
