import 'package:work_orders_data/work_orders_data.dart';
import 'package:test/test.dart';

void main() {
  test('DTO JSON round-trip and explicit entity mapping', () {
    const dto = WorkOrdersItemDto(id: '1', title: 'Sample');
    expect(WorkOrdersItemDto.fromJson(dto.toJson()), dto);
    expect(dto.toEntity().id, '1');
  });
}
