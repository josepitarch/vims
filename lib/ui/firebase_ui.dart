import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';

class LabelOverrides extends DefaultLocalizations {
  const LabelOverrides();

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

  @override
  String get signInHintText => '¿Ya tienes cuenta?';

  @override
  String get forgotPasswordViewTitle => '¿Olvidaste tu contraseña?';

  @override
  String get passwordResetEmailSentText =>
      'Te hemos enviado un correo con un enlace para restablecer tu contraseña. Por favor, revisa tu bandeja de entrada.';

  @override
  String get signInWithGoogleButtonText => 'Acceder con Google';

  @override
  String get signInWithAppleButtonText => 'Acceder con Apple';

  @override
  String get unknownError => 'Ha ocurrido un error inesperado';
}
