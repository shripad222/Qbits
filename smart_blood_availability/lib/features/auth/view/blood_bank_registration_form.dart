import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_blood_availability/features/auth/viewmodel/blood_bank_form_viewmodel.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class BloodBankRegistrationForm extends ConsumerWidget {
  // If embeddedInHospital is true, form will hide fields that would be
  // duplicated in the parent hospital registration form (like location/name)
  final bool embeddedInHospital;
  const BloodBankRegistrationForm({super.key, this.embeddedInHospital = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(bloodBankFormViewModelProvider.notifier);
    final state = ref.watch(bloodBankFormViewModelProvider);

    const availableAccreditations = ['AABB', 'NABH', 'ISO', 'Other'];
    const availableServices = [
      'Whole Blood',
      'Platelets',
      'Plasma',
      'Apheresis',
    ];

    return Form(
      key: viewModel.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Blood Bank Registration',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Profile image upload
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => viewModel.pickProfileImage(),
                icon: const Icon(Icons.photo_camera),
                label: const Text('Upload Photo'),
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

          if (!embeddedInHospital) ...[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Blood Bank Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => viewModel.updateField('name', v),
            ),
            const SizedBox(height: 12),
          ],

          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Parent Organization (if any)',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => viewModel.updateField('parentOrganization', v),
          ),
          const SizedBox(height: 12),

          TextFormField(
            decoration: const InputDecoration(
              labelText: 'License / Registration Number',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => viewModel.updateField('licenseNumber', v),
          ),
          const SizedBox(height: 12),

          // Accreditations
          const Text(
            'Accreditations (select all that apply)',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Wrap(
            spacing: 8,
            children: availableAccreditations.map((acc) {
              final selected = viewModel.accreditations.contains(acc);
              return FilterChip(
                label: Text(acc),
                selected: selected,
                onSelected: (s) => viewModel.toggleAccreditation(acc, s),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // PDF Upload
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
          const SizedBox(height: 12),

          // Location (if not embedded in hospital show location fields)
          if (!embeddedInHospital) ...[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Location (Street Address)',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => viewModel.updateField('location', v),
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
                    onChanged: (v) => viewModel.updateField('city', v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'State / Province',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => viewModel.updateField('stateProvince', v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: TextEditingController(text: viewModel.pincode),
                    decoration: const InputDecoration(
                      labelText: 'Pincode',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => viewModel.updateField('pincode', v),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    viewModel.useDeviceLocation();
                  },
                  child: const Text('Find Coordinates'),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Contact Number',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => viewModel.updateField('contactNumber', v),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: const InputDecoration(
              labelText: '24/7 Contact Number (if any)',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => viewModel.updateField('contact24x7', v),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => viewModel.updateField('email', v),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),

          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Operating Hours (e.g., 09:00-18:00)',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => viewModel.updateField('operatingHours', v),
          ),
          const SizedBox(height: 12),

          const Text(
            'Services Offered',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Wrap(
            spacing: 8,
            children: availableServices.map((s) {
              final selected = viewModel.services.contains(s);
              return FilterChip(
                label: Text(s),
                selected: selected,
                onSelected: (sel) => viewModel.toggleService(s, sel),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          SwitchListTile(
            title: const Text('Do you organize donation camps?'),
            value: viewModel.organizesDonationCamp,
            onChanged: (v) {
              viewModel.setOrganizesDonationCamp(v);
            },
          ),
          const SizedBox(height: 12),

          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Service Area (comma separated)',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => viewModel.updateField('serviceArea', v),
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text('Register Blood Bank'),
            ),
          ),
        ],
      ),
    );
  }
}
