import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';

class LabelOverrides extends DefaultLocalizations {
  const LabelOverrides();

  // TODO: migrate to i18n

  @override
  String get emailInputLabel => 'Tu correo';

  @override
  String get passwordInputLabel => 'Tu contraseña';

  @override
  String get signInActionText => 'Acceder';

  @override
  String get emailIsRequiredErrorText => 'Por favor, introduce tu correo';

  @override
  String get passwordIsRequiredErrorText =>
      'Por favor, introduce tu contraseña';

  @override
  String get forgotPasswordButtonLabel => '¿Olvidaste tu contraseña?';

  @override
  String get registerActionText => 'Crear cuenta';

  @override
  String get confirmPasswordInputLabel => 'Confirma tu contraseña';

  @override
  String get isNotAValidEmailErrorText =>
      'Por favor, introduce un correo válido';

  @override
  String get userNotFoundErrorText =>
      'El correo introducido no está registrado';

  @override
  String get wrongOrNoPasswordErrorText => 'La contraseña es incorrecta';

  @override
  String get resetPasswordButtonLabel => 'Restablecer contraseña';

  @override
  String get forgotPasswordHintText =>
      'Introduce tu correo para restablecer tu contraseña';

  @override
  String get signInText => "Iniciar sesión";

  @override
  String get registerHintText => '¿No tienes cuenta?';

  @override
  String get registerText => 'Regístrate';

  @override
  String get goBackButtonLabel => 'Volver';
}
