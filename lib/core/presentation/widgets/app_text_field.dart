import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:niramoy_health_app/core/resources/app_sizes.dart';

/// App-wide text field with pre-configured variants for common input types.
///
/// Each variant sets the appropriate keyboard, icon, autofill hint, and
/// input constraints automatically. All variants accept [prefixIcon] and
/// [suffixIcon] overrides. For fully custom inputs use the default constructor.
///
/// ```dart
/// AppTextField.email(labelText: 'Email', controller: _email);
/// AppTextField.password(labelText: 'Password', controller: _password);
/// AppTextField(labelText: 'Notes', controller: _notes);          // generic
/// ```
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.enabled = true,
    this.maxLength,
    this.textInputAction,
    this.onChanged,
    this.textAlign = TextAlign.start,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.autofillHints,
    this.inputFormatters,
    this.isPassword = false,
  });

  // ── name ─────────────────────────────────────────────────────────
  /// Person icon · name keyboard · next action · name autofill.
  factory AppTextField.name({
    Key? key,
    required String labelText,
    String? hintText,
    String? errorText,
    TextEditingController? controller,
    FocusNode? focusNode,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? Function(String? value)? validator,
    void Function(String value)? onChanged,
    bool enabled = true,
  }) => AppTextField(
    key: key,
    labelText: labelText,
    hintText: hintText,
    errorText: errorText,
    controller: controller,
    focusNode: focusNode,
    keyboardType: TextInputType.name,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    validator: validator,
    textInputAction: TextInputAction.next,
    onChanged: onChanged,
    enabled: enabled,
    autofillHints: const [AutofillHints.name],
  );

  // ── email ────────────────────────────────────────────────────────
  /// Email icon · email keyboard · next action · email autofill.
  factory AppTextField.email({
    Key? key,
    required String labelText,
    String? hintText,
    String? errorText,
    TextEditingController? controller,
    FocusNode? focusNode,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool enabled = true,
  }) => AppTextField(
    key: key,
    labelText: labelText,
    hintText: hintText,
    errorText: errorText,
    controller: controller,
    focusNode: focusNode,
    keyboardType: TextInputType.emailAddress,
    prefixIcon: prefixIcon ?? const Icon(Icons.email),
    suffixIcon: suffixIcon,
    validator: validator,
    textInputAction: TextInputAction.next,
    onChanged: onChanged,
    enabled: enabled,
    autocorrect: false,
    enableSuggestions: false,
    autofillHints: const [AutofillHints.email],
  );

  // ── phone ────────────────────────────────────────────────────────
  /// Phone icon · phone keyboard · next action · phone autofill.
  /// Pass [inputFormatters] to add phone-number formatting.
  factory AppTextField.phone({
    Key? key,
    required String labelText,
    String? hintText,
    String? errorText,
    TextEditingController? controller,
    FocusNode? focusNode,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool enabled = true,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) => AppTextField(
    key: key,
    labelText: labelText,
    hintText: hintText,
    errorText: errorText,
    controller: controller,
    focusNode: focusNode,
    keyboardType: TextInputType.phone,
    prefixIcon: prefixIcon ?? const Icon(Icons.phone),
    suffixIcon: suffixIcon,
    validator: validator,
    textInputAction: TextInputAction.next,
    onChanged: onChanged,
    enabled: enabled,
    autocorrect: false,
    enableSuggestions: false,
    autofillHints: const [AutofillHints.telephoneNumber],
    inputFormatters: inputFormatters,
    maxLength: maxLength,
  );

  // ── otp ──────────────────────────────────────────────────────────
  /// Numeric keyboard · center-aligned · digits-only filter.
  /// [maxLength] defaults to 6. Character counter is hidden.
  factory AppTextField.otp({
    Key? key,
    required String labelText,
    String? hintText,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? Function(String? value)? validator,
    void Function(String value)? onChanged,
    bool enabled = true,
    int maxLength = 6,
    List<TextInputFormatter>? inputFormatters,
  }) => AppTextField(
    key: key,
    labelText: labelText,
    hintText: hintText,
    controller: controller,
    focusNode: focusNode,
    keyboardType: TextInputType.number,
    validator: validator,
    textInputAction: TextInputAction.done,
    onChanged: onChanged,
    enabled: enabled,
    maxLength: maxLength,
    textAlign: TextAlign.center,
    autocorrect: false,
    enableSuggestions: false,
    autofillHints: const [AutofillHints.oneTimeCode],
    inputFormatters:
        inputFormatters ?? [FilteringTextInputFormatter.digitsOnly],
  );

  // ── password ─────────────────────────────────────────────────────
  /// Lock icon · obscured text · automatic visibility toggle · password autofill.
  /// The toggle suffix icon is managed internally; do not pass [suffixIcon].
  factory AppTextField.password({
    Key? key,
    required String labelText,
    String? hintText,
    TextEditingController? controller,
    FocusNode? focusNode,
    Widget? prefixIcon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool enabled = true,
    TextInputAction? textInputAction,
  }) => AppTextField(
    key: key,
    labelText: labelText,
    hintText: hintText,
    controller: controller,
    focusNode: focusNode,
    keyboardType: TextInputType.visiblePassword,
    obscureText: true,
    prefixIcon: prefixIcon ?? const Icon(Icons.lock),
    isPassword: true,
    validator: validator,
    textInputAction: textInputAction ?? TextInputAction.done,
    onChanged: onChanged,
    enabled: enabled,
    autocorrect: false,
    enableSuggestions: false,
    autofillHints: const [AutofillHints.password],
  );

  final String labelText;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool enabled;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final TextAlign textAlign;
  final bool autocorrect;
  final bool enableSuggestions;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;

  /// When true the state manages an internal obscure toggle.
  /// Only the [password] factory sets this.
  final bool isPassword;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final effectiveObscure = widget.isPassword
        ? _obscureText
        : widget.obscureText;

    // Password fields get an auto-managed visibility toggle;
    // all other suffix icons pass through unchanged.
    final effectiveSuffixIcon = widget.isPassword && widget.suffixIcon == null
        ? IconButton(
            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() {
              _obscureText = !_obscureText;
            }),
          )
        : widget.suffixIcon;

    final errorColor = Theme.of(context).colorScheme.error;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: AppSizes.textFieldHeight,
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: widget.keyboardType,
            obscureText: effectiveObscure,
            textAlign: widget.textAlign,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            textInputAction: widget.textInputAction,
            onChanged: widget.onChanged,
            autocorrect: widget.autocorrect,
            enableSuggestions: widget.enableSuggestions,
            autofillHints: widget.autofillHints,
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              // Pass errorText so the border turns red, but hide the text.
              errorText: widget.errorText,
              errorStyle: const TextStyle(fontSize: 0, height: 0),
              prefixIcon: widget.prefixIcon,
              suffixIcon: effectiveSuffixIcon,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.space12,
                vertical: AppSizes.space4,
              ),
              // Hide Flutter's default "0/N" counter when maxLength is set.
              counterText: widget.maxLength != null ? '' : null,
            ),
            validator: widget.validator,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: AppSizes.space12,
            top: AppSizes.space4,
          ),
          child: Text(
            widget.errorText ?? '',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: widget.errorText != null ? errorColor : Colors.transparent,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
