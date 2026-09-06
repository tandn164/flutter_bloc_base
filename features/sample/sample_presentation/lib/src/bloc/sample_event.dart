import 'package:equatable/equatable.dart';

sealed class SampleEvent extends Equatable {
  const SampleEvent();

  @override
  List<Object?> get props => [];
}

class SampleStarted extends SampleEvent {
  const SampleStarted();
}

class SampleRefreshed extends SampleEvent {
  const SampleRefreshed();
}

class SampleLoadMore extends SampleEvent {
  const SampleLoadMore();
}

class SampleCreated extends SampleEvent {
  const SampleCreated(this.title);
  final String title;
  @override
  List<Object?> get props => [title];
}

class SampleToggled extends SampleEvent {
  const SampleToggled(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class SampleRenamed extends SampleEvent {
  const SampleRenamed(this.id, this.title);
  final String id;
  final String title;
  @override
  List<Object?> get props => [id, title];
}

class SampleDeleted extends SampleEvent {
  const SampleDeleted(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}
