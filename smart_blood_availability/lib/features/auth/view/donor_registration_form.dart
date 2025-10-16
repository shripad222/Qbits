import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_blood_availability/features/auth/viewmodel/donor_form_viewmodel.dart';
import 'package:smart_blood_availability/shared/widgets/app_dropdown.dart';
import 'dart:io';

class DonorRegistrationForm extends ConsumerWidget {
  const DonorRegistrationForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(donorFormViewModelProvider.notifier);
    final state = ref.watch(donorFormViewModelProvider);

    const List<String> bloodGroups = [
      'A+',
      'B+',
      'O+',
      'AB+',
      'A-',
      'B-',
      'O-',
      'AB-',
    ];

    return Form(
      key: viewModel.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Donor Registration',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Profile picture
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => viewModel.pickImage(),
                icon: const Icon(Icons.photo_camera),
                label: const Text('Upload Profile Pic'),
              ),
              const SizedBox(width: 12),
              if (viewModel.profileImagePath != null)
                Expanded(
                  child: Text(
                    viewModel.profileImagePath!.split('/').last,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (viewModel.profileImagePath != null) ...[
            SizedBox(
              height: 120,
              child: Image.file(File(viewModel.profileImagePath!)),
            ),
            const SizedBox(height: 12),
          ],
          // First & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => viewModel.updateField('firstName', val),
                  validator: (val) =>
                      val!.isEmpty ? 'First name required' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => viewModel.updateField('lastName', val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 2. Mobile Number
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Mobile Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            onChanged: (val) => viewModel.updateField('mobileNumber', val),
          ),
          const SizedBox(height: 16),
          // 3. Email Address
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (val) => viewModel.updateField('emailAddress', val),
            validator: (val) => val!.isEmpty ? 'Email is required' : null,
          ),
          const SizedBox(height: 16),
          // 4. Password
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            onChanged: (val) => viewModel.updateField('password', val),
            validator: (val) => val!.length < 6
                ? 'Password must be at least 6 characters'
                : null,
          ),
          const SizedBox(height: 16),
          // 5. Date of Birth
          TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              border: OutlineInputBorder(),
            ),
            controller: viewModel.dobController,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(
                  const Duration(days: 365 * 18),
                ),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) viewModel.updateField('dateOfBirth', picked);
            },
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
          const SizedBox(height: 16),
          // Location fields: Street, City, State, Pincode + Find Coordinates
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Location (Street Address)',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => viewModel.updateField('location', val),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => viewModel.updateField('city', val),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'State / Province',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) =>
                      viewModel.updateField('stateProvince', val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 8),
          if (viewModel.coordinates != null)
            Text(
              'Coordinates: ${viewModel.coordinates!.latitude.toStringAsFixed(6)}, ${viewModel.coordinates!.longitude.toStringAsFixed(6)}',
            ),
          const SizedBox(height: 16),
          // 7. Weight
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (val) => viewModel.updateField('weight', val),
          ),
          const SizedBox(height: 16),
          // 8. Date of last donation (optional)
          TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Date of Last Donation (if any)',
              border: OutlineInputBorder(),
            ),
            controller: viewModel.lastDonationController,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null)
                viewModel.updateField('dateOfLastDonation', picked);
            },
          ),
          const SizedBox(height: 16),
          // 9. Permanent / long-term health screening (5 questions)
          const Text(
            'Health Screening (Long-term)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            value: viewModel.healthScreening['chronic_conditions'] ?? false,
            onChanged: (v) => viewModel.updateHealthScreening(
              'chronic_conditions',
              v ?? false,
            ),
            title: const Text(
              'Do you have any chronic medical conditions? (e.g., diabetes, hypertension)',
            ),
          ),
          CheckboxListTile(
            value: viewModel.healthScreening['on_regular_medication'] ?? false,
            onChanged: (v) => viewModel.updateHealthScreening(
              'on_regular_medication',
              v ?? false,
            ),
            title: const Text('Are you on any regular medication?'),
          ),
          CheckboxListTile(
            value: viewModel.healthScreening['history_of_transfusion'] ?? false,
            onChanged: (v) => viewModel.updateHealthScreening(
              'history_of_transfusion',
              v ?? false,
            ),
            title: const Text('Have you ever received a blood transfusion?'),
          ),
          CheckboxListTile(
            value:
                viewModel.healthScreening['chronic_infectious_disease'] ??
                false,
            onChanged: (v) => viewModel.updateHealthScreening(
              'chronic_infectious_disease',
              v ?? false,
            ),
            title: const Text(
              'Do you have any chronic infectious disease (e.g., hepatitis, HIV)?',
            ),
          ),
          CheckboxListTile(
            value: viewModel.healthScreening['major_surgery_history'] ?? false,
            onChanged: (v) => viewModel.updateHealthScreening(
              'major_surgery_history',
              v ?? false,
            ),
            title: const Text(
              'Have you had any major surgery in the past year?',
            ),
          ),
          const SizedBox(height: 12),

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
