import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import '../../domain/entities/security_credential_entity.dart';
import 'security_state.dart';

final securityControllerProvider = AsyncNotifierProvider<SecurityController, SecurityState>(SecurityController.new);

class SecurityController extends AsyncNotifier<SecurityState> {
  @override
  Future<SecurityState> build() async => const SecurityState();

  void changeMode(SecurityMode mode) {
    final value = state.value;
    if (value != null) state = AsyncData(SecurityState(mode: mode));
  }

  void updateSecret(String secret) {
    final value = state.value;
    if (value != null) state = AsyncData(value.copyWith(secret: secret, clearError: true));
  }

  void updateConfirmSecret(String secret) {
    final value = state.value;
    if (value != null) state = AsyncData(value.copyWith(confirmSecret: secret, clearError: true));
  }

  Future<bool> save() async {
    final value = state.value;
    if (value == null) return false;
    if (!value.canSave) {
      state = AsyncData(value.copyWith(errorKey: 'security_mismatch'));
      return false;
    }
    state = AsyncData(value.copyWith(isSaving: true));
    final result = await ref.read(saveSecurityCredentialUseCaseProvider)(SecurityCredentialEntity(mode: value.mode, secret: value.secret));
    return result.fold(
      (failure) {
        state = AsyncData(value.copyWith(isSaving: false, errorKey: failure.message));
        return false;
      },
      (_) {
        state = AsyncData(value.copyWith(isSaving: false));
        return true;
      },
    );
  }
}
