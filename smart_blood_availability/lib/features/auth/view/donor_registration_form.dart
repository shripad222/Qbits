import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_blood_availability/features/auth/viewmodel/donor_form_viewmodel.dart';
import 'package:smart_blood_availability/shared/widgets/app_dropdown.dart';

class DonorRegistrationForm extends ConsumerWidget {
  const DonorRegistrationForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(donorFormViewModelProvider.notifier);
    final state = ref.watch(donorFormViewModelProvider);

    const List<String> bloodGroups = [
      'A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'
    ];

    return Form(
      key: viewModel.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Donor Registration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // 1. Full Name
          TextFormField(
            decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
            onChanged: (val) => viewModel.updateField('fullName', val),
            validator: (val) => val!.isEmpty ? 'Name is required' : null,
          ),
          const SizedBox(height: 16),
          // 2. Mobile Number
          TextFormField(
            decoration: const InputDecoration(labelText: 'Mobile Number', border: OutlineInputBorder()),
            keyboardType: TextInputType.phone,
            onChanged: (val) => viewModel.updateField('mobileNumber', val),
          ),
          const SizedBox(height: 16),
          // 3. Email Address
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
            keyboardType: TextInputType.emailAddress,
            onChanged: (val) => viewModel.updateField('emailAddress', val),
            validator: (val) => val!.isEmpty ? 'Email is required' : null,
          ),
          const SizedBox(height: 16),
          // 4. Password
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
            obscureText: true,
            onChanged: (val) => viewModel.updateField('password', val),
            validator: (val) => val!.length < 6 ? 'Password must be at least 6 characters' : null,
          ),
          const SizedBox(height: 16),
          // 6. Blood Group
          AppDropdown<String>(
            labelText: 'Blood Group',
            value: null, // Managed internally by viewmodel in a real flow
            items: bloodGroups,
            itemLabelMapper: (group) => group,
            onChanged: (val) => viewModel.updateField('bloodGroup', val),
          ),
          const SizedBox(height: 24),

          // The rest of the form fields (DOB, Location, Weight, Last Donation, Health)
          // would be added here in a similar structured manner...

          // Submit Button
          ElevatedButton(
            onPressed: state.isLoading ? null : viewModel.registerDonor,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: state.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Register as Donor'),
          ),

          // Error Display
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Registration Failed: ${state.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}