import 'package:equatable/equatable.dart';
import 'package:profile_domain/profile_domain.dart';

enum ProfileNoticeKind { success, error }

class ProfileNotice extends Equatable {
  const ProfileNotice({
    required this.message,
    required this.kind,
    required this.id,
  });

  final String message;
  final ProfileNoticeKind kind;
  final int id;

  @override
  List<Object?> get props => [message, kind, id];
}

sealed class ProfileState extends Equatable {
  const ProfileState({this.busy = false, this.notice});

  final bool busy;
  final ProfileNotice? notice;
}

class ProfileLoading extends ProfileState {
  const ProfileLoading({super.busy, super.notice});

  @override
  List<Object?> get props => [busy, notice];
}

class ProfileData extends ProfileState {
  const ProfileData(this.profile, {super.busy, super.notice});

  final UserProfile profile;

  @override
  List<Object?> get props => [profile, busy, notice];
}

class ProfileError extends ProfileState {
  const ProfileError(this.message, {super.busy, super.notice});

  final String message;

  @override
  List<Object?> get props => [message, busy, notice];
}
