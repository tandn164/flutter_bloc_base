import 'package:equatable/equatable.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

class ProfileSaved extends ProfileEvent {
  const ProfileSaved(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class ProfileSignedOut extends ProfileEvent {
  const ProfileSignedOut();
}
