import 'package:injectable/injectable.dart';
import 'package:app_result/app_result.dart';

import '../entities/sample_item.dart';
import '../repositories/sample_repository.dart';

@lazySingleton
class CreateSampleItem {
  CreateSampleItem(this._repository);

  final SampleRepository _repository;

  Future<Result<SampleItem>> execute({required String title}) {
    return _repository.createItem(title: title);
  }
}

@lazySingleton
class UpdateSampleItem {
  UpdateSampleItem(this._repository);

  final SampleRepository _repository;

  Future<Result<SampleItem>> execute({
    required String id,
    String? title,
    bool? done,
  }) {
    return _repository.updateItem(id: id, title: title, done: done);
  }
}

@lazySingleton
class DeleteSampleItem {
  DeleteSampleItem(this._repository);

  final SampleRepository _repository;

  Future<Result<SampleItem>> execute({required String id}) {
    return _repository.deleteItem(id: id);
  }
}
