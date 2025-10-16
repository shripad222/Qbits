import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_blood_availability/features/auth/viewmodel/hospital_form_viewmodel.dart';
import 'package:smart_blood_availability/shared/widgets/app_dropdown.dart';
// NOTE: Placeholder for the dynamically loaded form
// import 'blood_bank_registration_form.dart';

class HospitalRegistrationForm extends ConsumerWidget {
  const HospitalRegistrationForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(hospitalFormViewModelProvider.notifier);
    final state = ref.watch(hospitalFormViewModelProvider);
    final internalBBStatus = state.value ?? false; // Status of internal blood bank

    const List<String> hospitalTypes = ['Government', 'Private'];

    return Form(
      key: viewModel.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Hospital Registration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // 1. Name of Hospital
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name of Hospital', border: OutlineInputBorder()),
            onChanged: (val) => viewModel.updateField('name', val),
            validator: (val) => val!.isEmpty ? 'Hospital name is required' : null,
          ),
          const SizedBox(height: 16),
          // 2. License Number
          TextFormField(
            decoration: const InputDecoration(labelText: 'License Number', border: OutlineInputBorder()),
            onChanged: (val) => viewModel.updateField('licenseNumber', val),
            validator: (val) => val!.isEmpty ? 'License Number is required' : null,
          ),
          const SizedBox(height: 16),
          // 3. Type
          AppDropdown<String>(
            labelText: 'Type',
            value: null,
            items: hospitalTypes,
            itemLabelMapper: (type) => type,
            onChanged: (val) => viewModel.updateField('type', val),
          ),
          const SizedBox(height: 16),
          // 4-7. Location Fields (Street, City, State, Pincode)
          TextFormField(
            decoration: const InputDecoration(labelText: 'Location (Street Address)', border: OutlineInputBorder()),
            onChanged: (val) => viewModel.updateField('location', val),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
            onChanged: (val) => viewModel.updateField('city', val),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'State / Province', border: OutlineInputBorder()),
            onChanged: (val) => viewModel.updateField('stateProvince', val),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Pincode', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            onChanged: (val) => viewModel.updateField('pincode', val),
          ),
          const SizedBox(height: 24),

          // 11. CRITICAL: Internal Blood Bank Available Checkbox 
          Row(
            children: [
              Checkbox(
                value: internalBBStatus,
                onChanged: viewModel.toggleInternalBloodBank,
              ),
              const Flexible(
                child: Text('Internal Blood Bank Available (Check this box to include Blood Bank details)', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Conditional Display of Blood Bank Form Fields 
          // The Blood Bank Form will appear if the CRITICAL checkbox is checked.
          if (internalBBStatus) ...[
            const Divider(height: 40),
            const Text('Blood Bank Details (Continuation)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 16),
            // Placeholder: The actual Blood Bank form/fields (from the next step)
            // will be injected here. For now, we use a simple text.
            const Text(
              '**The full Blood Bank Registration Form UI will be inserted here**',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
          ],

          // Submit Button
          ElevatedButton(
            onPressed: state.isLoading ? null : viewModel.registerHospital,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: state.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Register Hospital'),
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