// lib/features/auth/presentation/form/register_form.dart
import 'package:disfruta_antofagasta/features/auth/presentation/state/register/register_provider.dart';
import 'package:disfruta_antofagasta/features/auth/domain/entities/country.dart';
import 'package:disfruta_antofagasta/config/theme/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _registerObscureProvider = StateProvider.autoDispose<bool>((_) => true);

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  @override
  void initState() {
    super.initState();
    // carga países al montar
    Future.microtask(() => ref.read(registerFormProvider.notifier).bootstrap());
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(registerFormProvider);
    final n = ref.read(registerFormProvider.notifier);
    final obscure = ref.watch(_registerObscureProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Nombre / Apellido
        Row(
          children: [
            Expanded(
              child: _rounded(
                hint: 'Nombre',
                onChanged: (v) => n.setField('name', v),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requerido';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _rounded(
                hint: 'Apellido',
                onChanged: (v) => n.setField('last', v),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requerido';
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _rounded(
                hint: 'Edad',
                keyboard: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                suffix: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Text('años', style: TextStyle(color: Colors.black54)),
                ),
                onChanged: (v) => n.setField('age', v),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requerido';
                  final n = int.tryParse(v);
                  if (n == null) return 'Solo números';
                  if (n <= 1) return 'Mayor a 1';
                  if (n > 120) return 'Edad inválida';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _rounded(
                hint: 'Días de visita',
                keyboard: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                suffix: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Text('días', style: TextStyle(color: Colors.black54)),
                ),
                onChanged: (v) => n.setField('stay', v),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requerido';
                  final n = int.tryParse(v);
                  if (n == null) return 'Solo números';
                  if (n <= 0) return 'Debe ser > 0';
                  if (n > 365) return 'Máx 365';
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Email
        _rounded(
          hint: 'Correo electrónico',
          keyboard: TextInputType.emailAddress,
          onChanged: (v) => n.setField('email', v),
        ),
        const SizedBox(height: 12),

        // Password
        _rounded(
          hint: 'Contraseña',
          obscure: obscure,
          suffix: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () =>
                ref.read(_registerObscureProvider.notifier).state = !obscure,
          ),
          onChanged: (v) => n.setField('pass', v),
        ),
        const SizedBox(height: 8),

        // País
        DropdownButtonFormField<Country>(
          initialValue: s.selectedCountry,
          isExpanded: true,
          dropdownColor: Colors.white,
          iconEnabledColor: Colors.black45,
          style: const TextStyle(color: Colors.black),
          hint: const Text('País', style: TextStyle(color: Colors.black54)),
          decoration: _decoration(
            'País',
            prefix: const Icon(Icons.public_outlined),
          ),
          items: s.countries
              .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
              .toList(),
          onChanged: s.isLoadingCountries ? null : n.countryChanged,
        ),
        if (s.isLoadingCountries)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: LinearProgressIndicator(minHeight: 2),
          ),
        const SizedBox(height: 12),

        // Región (solo si el país lo requiere)
        if (s.needsRegion) ...[
          DropdownButtonFormField<int>(
            initialValue: s.selectedRegionId,
            isExpanded: true,
            dropdownColor: Colors.white,
            iconEnabledColor: Colors.black45,
            style: const TextStyle(color: Colors.black),
            hint: const Text('Región', style: TextStyle(color: Colors.black54)),
            decoration: _decoration(
              'Región',
              prefix: const Icon(Icons.map_outlined),
            ),
            items: s.regions
                .map((r) => DropdownMenuItem(value: r.id, child: Text(r.name)))
                .toList(),
            onChanged: s.isLoadingRegions ? null : n.regionChanged,
          ),
          if (s.isLoadingRegions)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: LinearProgressIndicator(minHeight: 2),
            ),
          const SizedBox(height: 12),
        ],

        if (s.error != null) ...[
          Text(s.error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 8),
        ],

        // 🔴 Botón "Crear cuenta" vinotinto
        SizedBox(
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.panelWine,
              foregroundColor: AppColors.textOnPanel,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            onPressed: s.isPosting ? null : n.submit,
            child: Text(s.isPosting ? 'Creando…' : 'Crear cuenta'),
          ),
        ),
      ],
    );
  }

  Widget _rounded({
    required String hint,
    TextInputType? keyboard,
    bool obscure = false,
    Widget? suffix,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      onChanged: onChanged,
      keyboardType: keyboard,
      obscureText: obscure,
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      decoration: _decoration(hint, suffix: suffix),
    );
  }

  InputDecoration _decoration(String hint, {Widget? prefix, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54),
      prefixIcon: prefix,
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.92),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        borderSide: BorderSide(color: Color(0xFF0E4560), width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: Colors.red.withValues(alpha: 0.5)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        borderSide: BorderSide(color: Colors.red, width: 1.2),
      ),
    );
  }
}
