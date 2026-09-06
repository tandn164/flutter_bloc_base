import 'package:injectable/injectable.dart';
import '../profile_callbacks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_domain/profile_domain.dart';

import 'profile_event.dart';
import 'profile_state.dart';

export 'profile_event.dart';
export 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required GetProfile getProfile,
    required UpdateProfile updateProfile,
    @factoryParam required OnProfileSignOut onSignOut,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        _onSignOut = onSignOut,
        super(const ProfileLoading()) {
    on<ProfileStarted>(_load);
    on<ProfileSaved>(_save);
    on<ProfileSignedOut>(_signOut);
  }

  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;
  final Future<void> Function() _onSignOut;
  int _noticeId = 0;

  ProfileNotice _notice(String message, ProfileNoticeKind kind) {
    return ProfileNotice(message: message, kind: kind, id: ++_noticeId);
  }

  Future<void> _load(ProfileStarted event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    final result = await _getProfile.execute();
    result.fold(
      ok: (profile) => emit(ProfileData(profile)),
      err: (f) => emit(ProfileError(
        f.message,
        notice: _notice(f.message, ProfileNoticeKind.error),
      )),
    );
  }

  Future<void> _save(ProfileSaved event, Emitter<ProfileState> emit) async {
    final current = state;
    if (current is ProfileData) {
      emit(ProfileData(current.profile, busy: true));
    }
    try {
      final result = await _updateProfile.execute(name: event.name);
      result.fold(
        ok: (profile) => emit(ProfileData(
          profile,
          notice: _notice('Profile updated', ProfileNoticeKind.success),
        )),
        err: (f) {
          if (current is ProfileData) {
            emit(ProfileData(
              current.profile,
              notice: _notice(f.message, ProfileNoticeKind.error),
            ));
          } else {
            emit(ProfileError(
              f.message,
              notice: _notice(f.message, ProfileNoticeKind.error),
            ));
          }
        },
      );
    } finally {
      if (!isClosed && state.busy) {
        final latest = state;
        if (latest is ProfileData) {
          emit(ProfileData(latest.profile, notice: latest.notice));
        } else if (latest is ProfileError) {
          emit(ProfileError(latest.message, notice: latest.notice));
        }
      }
    }
  }

  Future<void> _signOut(
      ProfileSignedOut event, Emitter<ProfileState> emit) async {
    await _onSignOut();
  }
}
