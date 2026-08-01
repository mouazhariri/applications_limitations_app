import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:applications_limitations/src/core/di/service_locator.dart';
import '../../domain/entities/security_credential_entity.dart';
import 'security_state.dart';

part 'security_controller.g.dart';

@riverpod
class SecurityController extends _$SecurityController {
  @override
  Future<SecurityState> build() async => const SecurityState();

  void changeMode(SecurityMode mode) {
    final data = state.value;
    if (data == null) return;
    state = AsyncData(SecurityState(mode: mode));
  }

  void updateSecret(String secret) {
    final data = state.value;
    if (data == null) return;
    state = AsyncData(data.copyWith(secret: secret, clearError: true));
  }

  void updateConfirmSecret(String secret) {
    final data = state.value;
    if (data == null) return;
    state = AsyncData(data.copyWith(confirmSecret: secret, clearError: true));
  }

  Future<bool> save() async {
    final data = state.value;
    if (data == null) return false;
    if (!data.canSave) {
      state = AsyncData(data.copyWith(errorKey: 'security_mismatch'));
      return false;
    }

    state = AsyncData(data.copyWith(isSaving: true));
    final result = await ref.read(saveSecurityCredentialUseCaseProvider)(
      SecurityCredentialEntity(mode: data.mode, secret: data.secret),
    );

    return result.fold(
      (failure) {
        state = AsyncData(
          data.copyWith(isSaving: false, errorKey: failure.message),
        );
        return false;
      },
      (_) {
        state = AsyncData(data.copyWith(isSaving: false));
        return true;
      },
    );
  }
}
