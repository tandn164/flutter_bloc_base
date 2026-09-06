import 'package:injectable/injectable.dart';
import 'package:api_client/api_client.dart';
import 'package:app_result/app_result.dart';
import 'package:sample_domain/sample_domain.dart';

import '../api/sample_api.dart';
import '../dtos/sample_item_dto.dart';

@LazySingleton()
class SampleRepositoryImpl implements SampleRepository {
  SampleRepositoryImpl({required this.api});

  @factoryMethod
  static SampleRepositoryImpl create(SampleApi api) =>
      SampleRepositoryImpl(api: api);

  final SampleApi api;

  @override
  Future<Result<SampleChunk>> getSample(
      {int page = 1, bool forceNetwork = false}) {
    return chopperResult(
      () => api.getSample(
        page,
        SampleRepository.pageSize,
      ),
      (json) {
        final map = json as Map<String, dynamic>;
        return SampleChunk(
          items: [
            for (final dto in SampleItemDto.listFromJson(json)) dto.toEntity(),
          ],
          hasMore: map['hasMore'] as bool? ?? false,
        );
      },
    );
  }

  @override
  Future<Result<SampleItem>> createItem({required String title}) {
    return chopperResult(
      () => api.createSample(
        {'title': title},
      ),
      _item,
    );
  }

  @override
  Future<Result<SampleItem>> updateItem({
    required String id,
    String? title,
    bool? done,
  }) {
    return chopperResult(
      () => api.updateSample(
        id,
        {
          if (title != null) 'title': title,
          if (done != null) 'done': done,
        },
      ),
      _item,
    );
  }

  @override
  Future<Result<SampleItem>> deleteItem({required String id}) {
    return chopperResult(
      () => api.deleteSample(
        id,
      ),
      _item,
    );
  }

  static SampleItem _item(Object json) {
    return SampleItemDto.fromJson(json as Map<String, dynamic>).toEntity();
  }
}
