import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_blood_availability/features/auth/viewmodel/hospital_form_viewmodel.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:smart_blood_availability/shared/widgets/app_dropdown.dart';
import 'blood_bank_registration_form.dart';

class HospitalRegistrationForm extends ConsumerWidget {
  const HospitalRegistrationForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(hospitalFormViewModelProvider.notifier);
    final state = ref.watch(hospitalFormViewModelProvider);
    final internalBBStatus =
        state.value ?? false; // Status of internal blood bank

    const List<String> hospitalTypes = ['Government', 'Private'];

    return Form(
      key: viewModel.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Hospital Registration',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Image upload (hospital photo/logo)
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => viewModel.pickImage(),
                icon: const Icon(Icons.photo_camera),
                label: const Text('Upload Hospital Image'),
              ),
              const SizedBox(width: 12),
              if (viewModel.hospitalImagePath != null)
                Expanded(
                  child: Text(
                    viewModel.hospitalImagePath!.split('/').last,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // 1. Name of Hospital
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Name of Hospital',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => viewModel.updateField('name', val),
            validator: (val) =>
                val!.isEmpty ? 'Hospital name is required' : null,
          ),
          const SizedBox(height: 16),
          // 2. License Number
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'License Number',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => viewModel.updateField('licenseNumber', val),
            validator: (val) =>
                val!.isEmpty ? 'License Number is required' : null,
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
          // Registration certificate (PDF) upload
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => viewModel.pickPdf(),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Upload Registration (PDF)'),
              ),
              const SizedBox(width: 12),
              if (viewModel.registrationPdfPath != null)
                Expanded(
                  child: Text(
                    viewModel.registrationPdfPath!.split('/').last,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // 4-7. Location Fields (Street, City, State, Pincode)
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Location (Street Address)',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => viewModel.updateField('location', val),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'City',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => viewModel.updateField('city', val),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'State / Province',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => viewModel.updateField('stateProvince', val),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: viewModel.pincodeController,
                  decoration: const InputDecoration(
                    labelText: 'Pincode',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => viewModel.updateField('pincode', val),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => viewModel.fetchCoordinatesFromAddress(),
                child: const Text('Find Coordinates'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => viewModel.useDeviceLocation(),
                child: const Text('Use my current location'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Coordinates display (non-editable)
          if (viewModel.coordinates != null) ...[
            Text(
              'Coordinates: ${viewModel.coordinates!.latitude.toStringAsFixed(6)}, ${viewModel.coordinates!.longitude.toStringAsFixed(6)}',
            ),
            const SizedBox(height: 8),
          ],

          // Image preview
          if (viewModel.hospitalImagePath != null) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: Image.file(File(viewModel.hospitalImagePath!)),
            ),
            const SizedBox(height: 8),
          ],

          // PDF preview/open
          if (viewModel.registrationPdfPath != null) ...[
            ElevatedButton.icon(
              onPressed: () => OpenFile.open(viewModel.registrationPdfPath),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Open Uploaded PDF'),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 24),

          // 11. CRITICAL: Internal Blood Bank Available Checkbox
          Row(
            children: [
              Checkbox(
                value: internalBBStatus,
                onChanged: viewModel.toggleInternalBloodBank,
              ),
              const Flexible(
                child: Text(
                  'Internal Blood Bank Available (Check this box to include Blood Bank details)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Conditional Display of Blood Bank Form Fields
          // The Blood Bank Form will appear if the CRITICAL checkbox is checked.
          if (internalBBStatus) ...[
            const Divider(height: 40),
            const Text(
              'Blood Bank Details (Continuation)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            const BloodBankRegistrationForm(embeddedInHospital: true),
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
