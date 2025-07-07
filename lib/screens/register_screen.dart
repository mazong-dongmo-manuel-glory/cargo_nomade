// FILE: lib/screens/register_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

// --- STYLES ET COULEURS POUR LA COHÉRENCE ---
const Color primaryColor = Color(0xFF4CAF50);
const Color primaryLightColor = Color(0xFF00E676);
const Color primaryDarkColor = Color(0xFF2E7D32);
const Color textColorDark = Color(0xFF2D3748);
const Color textColorLight = Color(0xFF718096);
const Color backgroundColor = Color(0xFFF7FAFC);

// --- ÉCRAN PRINCIPAL ---
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Redirection si l'utilisateur est déjà authentifié
        if (authProvider.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => context.go('/home'),
          );
        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            // Le bouton retour disparaît sur l'écran de confirmation de code
            leading: authProvider.codeIsSent ? null : _buildBackButton(context),
          ),
          body: Container(
            decoration: _buildGradientBackground(),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildLogo(),
                    const SizedBox(height: 30),
                    _buildTitle(),
                    const SizedBox(height: 60),
                    // Animation fluide entre les deux formulaires
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      ),
                      child: authProvider.codeIsSent
                          ? const ConfirmationCodeForm()
                          : const EnterUserInfoForm(),
                    ),
                    const SizedBox(height: 40),
                    if (authProvider.errorMsg.isNotEmpty)
                      _buildErrorDisplay(authProvider),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- WIDGETS D'UI STATIQUES ---
  Widget _buildBackButton(BuildContext context) => Container(
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: IconButton(
      onPressed: () => context.go('/'),
      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
    ),
  );

  BoxDecoration _buildGradientBackground() => const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primaryLightColor, primaryColor, primaryDarkColor],
    ),
  );

  Widget _buildLogo() => Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: const Icon(
      Icons.local_shipping_rounded,
      size: 50,
      color: Colors.white,
    ),
  );

  Widget _buildTitle() => Column(
    children: [
      Text(
        "Cargo Nomade",
        style: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        "Bienvenue dans votre aventure !",
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    ],
  );

  Widget _buildErrorDisplay(AuthProvider authProvider) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.red.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.red.withOpacity(0.3)),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            authProvider.errorMsg,
            style: GoogleFonts.poppins(
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          onPressed: authProvider.clearError,
          icon: const Icon(Icons.close, color: Colors.red, size: 16),
        ),
      ],
    ),
  );
}

// --- WIDGET POUR LE FORMULAIRE D'INFORMATIONS ---
class EnterUserInfoForm extends StatefulWidget {
  const EnterUserInfoForm({super.key});

  @override
  State<EnterUserInfoForm> createState() => _EnterUserInfoFormState();
}

class _EnterUserInfoFormState extends State<EnterUserInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      // Le pays est déjà dans le provider grâce à `onInputChanged`
      authProvider.verifyNumber(name: _nameController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Container(
      key: const ValueKey('userInfoForm'),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Créer votre compte",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColorDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildTextFormField(
              _nameController,
              "Nom complet",
              Icons.person_outline_rounded,
              validator: (v) => (v == null || v.trim().length < 3)
                  ? "Le nom est trop court"
                  : null,
            ),
            const SizedBox(height: 16),
            _buildPhoneNumberInput(authProvider),
            const SizedBox(height: 16),
            _buildTermsCheckbox(authProvider),
            const SizedBox(height: 24),
            _buildSubmitButton(authProvider, "Continuer", _submitForm),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String label,
    IconData icon, {
    String? Function(String?)? validator,
  }) {
    final authProvider = context.read<AuthProvider>();
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: textColorDark), // Texte saisi en noir
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      validator: validator,
      enabled: !authProvider.isLoading,
    );
  }

  Widget _buildPhoneNumberInput(AuthProvider authProvider) {
    return InternationalPhoneNumberInput(
      textStyle: const TextStyle(color: textColorDark),
      // Ce callback met à jour le numéro ET le code pays (isoCode) dans le provider.
      onInputChanged: authProvider.setPhoneNumber,
      onInputValidated: authProvider.setIsValidPhoneNumber,
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        trailingSpace: false,
      ),
      searchBoxDecoration: InputDecoration(hintText: "Entrer un pays"),
      inputDecoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Numéro de téléphone",
      ),
      isEnabled: !authProvider.isLoading,
      // Pré-remplit le champ si l'utilisateur revient en arrière
      initialValue: authProvider.phoneNumber,
    );
  }

  Widget _buildTermsCheckbox(AuthProvider authProvider) {
    return CheckboxListTile(
      title: Text(
        "J'accepte les conditions d'utilisation",
        style: GoogleFonts.poppins(fontSize: 13, color: textColorLight),
      ),
      value: authProvider.isAccepted,
      onChanged: authProvider.isLoading ? null : authProvider.setIsAccepted,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: primaryColor,
    );
  }

  Widget _buildSubmitButton(
    AuthProvider authProvider,
    String text,
    VoidCallback onPressed,
  ) {
    // Le bouton est actif seulement si les conditions sont remplies
    final bool canSubmit =
        !authProvider.isLoading &&
        authProvider.isAccepted &&
        authProvider.isValidPhoneNumber;

    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: canSubmit ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          disabledBackgroundColor: primaryColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: authProvider.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Text(
                text,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}

// --- WIDGET POUR LE FORMULAIRE DE CODE DE CONFIRMATION ---
class ConfirmationCodeForm extends StatefulWidget {
  const ConfirmationCodeForm({super.key});
  @override
  State<ConfirmationCodeForm> createState() => _ConfirmationCodeFormState();
}

class _ConfirmationCodeFormState extends State<ConfirmationCodeForm> {
  final _codeController = TextEditingController();
  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Container(
      key: const ValueKey('confirmationCodeForm'),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Vérification",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColorDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.poppins(color: textColorLight, fontSize: 14),
              children: [
                const TextSpan(text: "Code envoyé au "),
                TextSpan(
                  text: authProvider.fullPhoneNumber ?? "votre numéro",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColorDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            enabled: !authProvider.isLoading,
            style: GoogleFonts.poppins(
              fontSize: 32,
              letterSpacing: 12,
              fontWeight: FontWeight.bold,
              color: textColorDark,
            ),
            decoration: InputDecoration(
              counterText: "",
              hintText: "------",
              hintStyle: TextStyle(color: textColorLight.withOpacity(0.5)),
            ),
            onChanged: (value) {
              if (value.length == 6) {
                authProvider.verifyCode(value);
              }
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed:
                  (authProvider.isLoading || _codeController.text.length != 6)
                  ? null
                  : () => authProvider.verifyCode(_codeController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: authProvider.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Text(
                      "Vérifier",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          TextButton(
            onPressed: authProvider.isLoading
                ? null
                : authProvider.changePhoneNumber,
            child: Text(
              "Modifier le numéro",
              style: GoogleFonts.poppins(color: textColorLight),
            ),
          ),
        ],
      ),
    );
  }
}
