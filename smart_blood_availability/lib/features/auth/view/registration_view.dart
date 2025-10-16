import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_blood_availability/features/auth/viewmodel/registration_viewmodel.dart';
import 'donor_registration_form.dart';
// Import other forms
import 'hospital_registration_form.dart';
import 'blood_bank_registration_form.dart';

class RegistrationView extends ConsumerWidget {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRole = ref.watch(registrationViewModelProvider);
    final viewModel = ref.read(registrationViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Unified Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Role Selector (UI/UX Mandate) [cite: 9]
            _buildRoleSelector(selectedRole, viewModel),
            const SizedBox(height: 32),

            // Dynamic Form Display (UI/UX Mandate) [cite: 11]
            _buildCurrentForm(selectedRole),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelector(
    UserRole selectedRole,
    RegistrationViewModel viewModel,
  ) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: UserRole.values.map((role) {
          final isSelected = role == selectedRole;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(role.name.toUpperCase()),
                selected: isSelected,
                onSelected: (_) => viewModel.selectRole(role),
                selectedColor: Colors.red.shade100,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.red.shade700 : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCurrentForm(UserRole role) {
    switch (role) {
      case UserRole.donor:
        return const DonorRegistrationForm(); // Default View [cite: 10]
      case UserRole.hospital:
        return const HospitalRegistrationForm();
      case UserRole.bloodBank:
        return const BloodBankRegistrationForm();
    }
  }
}
