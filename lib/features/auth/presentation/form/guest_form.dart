// lib/features/auth/presentation/form/guest_form.dart
import 'package:disfruta_antofagasta/features/auth/presentation/state/guest/guest_provider.dart';
import 'package:disfruta_antofagasta/features/auth/domain/entities/country.dart';
import 'package:disfruta_antofagasta/config/theme/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuestForm extends ConsumerStatefulWidget {
  const GuestForm({super.key});

  @override
  ConsumerState<GuestForm> createState() => _GuestFormState();
}

class _GuestFormState extends ConsumerState<GuestForm> {
  @override
  void initState() {
    super.initState();
    // Carga países una sola vez
    Future.microtask(() => ref.read(guestFormProvider.notifier).bootstrap());
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(guestFormProvider);
    final n = ref.read(guestFormProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Nombre
        TextFormField(
          style: const TextStyle(color: Colors.black),
          initialValue: s.name,
          onChanged: n.nameChanged,
          decoration: _glassInput(
            'Nombre',
            prefix: const Icon(Icons.person_outline),
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Requerido';
            return null;
          },
        ),
        const SizedBox(height: 12),

        // Edad (> 1 y <= 120)
        TextFormField(
          style: const TextStyle(color: Colors.black),
          initialValue: s.age?.toString() ?? '',
          onChanged: n.ageChanged,
          keyboardType: const TextInputType.numberWithOptions(
            signed: false,
            decimal: false,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Requerido';
            final x = int.tryParse(v);
            if (x == null) return 'Solo números';
            if (x <= 1) return 'Debe ser > 1';
            if (x > 120) return 'Edad inválida';
            return null;
          },
          decoration: _glassInput(
            'Edad',
            prefix: const Icon(Icons.cake_outlined),
            suffixText: 'años',
          ),
        ),
        const SizedBox(height: 12),

        // Días de visita (> 0 y <= 365)
        TextFormField(
          style: const TextStyle(color: Colors.black),
          initialValue: s.stay?.toString() ?? '',
          onChanged: n.daysStayChanged,
          keyboardType: const TextInputType.numberWithOptions(
            signed: false,
            decimal: false,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Requerido';
            final x = int.tryParse(v);
            if (x == null) return 'Solo números';
            if (x <= 0) return 'Debe ser > 0';
            if (x > 365) return 'Máx 365';
            return null;
          },
          decoration: _glassInput(
            'Días de visita',
            prefix: const Icon(Icons.today_outlined),
            suffixText: 'días',
          ),
        ),
        const SizedBox(height: 12),

        // País
        DropdownButtonFormField<Country>(
          initialValue: s.selectedCountry,
          isExpanded: true,
          dropdownColor: Colors.white,
          iconEnabledColor: Colors.black45,
          style: const TextStyle(color: Colors.black),
          hint: const Text('País', style: TextStyle(color: Colors.black54)),
          decoration: _glassInput(
            'País',
            prefix: const Icon(Icons.public_outlined),
          ),
          items: s.countries
              .map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: Text(
                    '${c.name} ',
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              )
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
            decoration: _glassInput(
              'Región',
              prefix: const Icon(Icons.map_outlined),
            ),
            items: s.regions
                .map(
                  (r) => DropdownMenuItem(
                    value: r.id,
                    child: Text(
                      r.name,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                )
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

        // 🔴 Botón "Entrar como invitado" vinotinto
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
            onPressed: s.canSubmit ? n.submit : null,
            child: Text(s.isPosting ? 'Entrando…' : 'Entrar como invitado'),
          ),
        ),
      ],
    );
  }

  InputDecoration _glassInput(
    String hint, {
    Widget? prefix,
    String? suffixText,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54),
      prefixIcon: prefix,
      prefixIconColor: Colors.black45,
      suffixIcon: suffix,
      suffixIconColor: Colors.black45,
      suffixText: suffixText,
      suffixStyle: const TextStyle(color: Colors.black54),
      labelStyle: const TextStyle(color: Colors.black),
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
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        borderSide: BorderSide(color: Colors.red, width: 1.2),
      ),
    );
  }
}
