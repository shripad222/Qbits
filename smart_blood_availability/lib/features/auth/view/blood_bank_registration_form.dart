import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_blood_availability/features/auth/viewmodel/blood_bank_form_viewmodel.dart';
import 'dart:io';

class BloodBankRegistrationForm extends ConsumerWidget {
  final bool embeddedInHospital;
  const BloodBankRegistrationForm({super.key, this.embeddedInHospital = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(bloodBankFormViewModelProvider.notifier);
    final state = ref.watch(bloodBankFormViewModelProvider);

    const availableAccreditations = ['AABB', 'NABH', 'ISO', 'Other'];

    return SingleChildScrollView(
      child: Container(
        decoration: !embeddedInHospital
            ? BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade50, Colors.white],
          ),
        )
            : null,
        child: Form(
          key: viewModel.formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!embeddedInHospital) ...[
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red.shade700, Colors.red.shade500],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.water_drop,
                          size: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Blood Bank Registration',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Provide quality blood services',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                ],

                // Profile Photo Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red.shade200,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.red.shade50,
                  ),
                  child: Column(
                    children: [
                      if (viewModel.profileImagePath == null)
                        Icon(
                          Icons.image_outlined,
                          size: 50,
                          color: Colors.red.shade300,
                        )
                      else
                        SizedBox(
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(viewModel.profileImagePath!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => viewModel.pickProfileImage(),
                        icon: const Icon(Icons.photo_camera),
                        label: const Text('Upload Blood Bank Photo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      if (viewModel.profileImagePath != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          viewModel.profileImagePath!.split('/').last,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Basic Information Section
                _buildSectionHeader('Basic Information'),
                const SizedBox(height: 12),
                if (!embeddedInHospital) ...[
                  _buildTextField(
                    'Blood Bank Name',
                        (v) => viewModel.updateField('name', v),
                  ),
                  const SizedBox(height: 12),
                ],
                _buildTextField(
                  'Parent Organization (if any)',
                      (v) => viewModel.updateField('parentOrganization', v),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'License / Registration Number',
                      (v) => viewModel.updateField('licenseNumber', v),
                ),
                const SizedBox(height: 24),

                // Accreditations Section
                _buildSectionHeader('Accreditations'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red.shade50,
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: availableAccreditations.map((acc) {
                      final selected = viewModel.accreditations.contains(acc);
                      return FilterChip(
                        label: Text(acc),
                        selected: selected,
                        onSelected: (s) =>
                            viewModel.toggleAccreditation(acc, s),
                        selectedColor: Colors.red.shade600,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        side: BorderSide(
                          color: selected
                              ? Colors.red.shade600
                              : Colors.red.shade300,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Registration Document Section
                _buildSectionHeader('Registration Document'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.amber.shade200,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.amber.shade50,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.picture_as_pdf,
                        size: 40,
                        color: Colors.amber.shade600,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => viewModel.pickPdf(),
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Upload Registration PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      if (viewModel.registrationPdfPath != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.amber.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.description,
                                color: Colors.amber.shade600,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  viewModel.registrationPdfPath!
                                      .split('/')
                                      .last,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.amber.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Location Section (if not embedded)
                if (!embeddedInHospital) ...[
                  _buildSectionHeader('Location Information'),
                  const SizedBox(height: 12),
                  _buildTextField(
                    'Street Address',
                        (v) => viewModel.updateField('location', v),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          'City',
                              (v) => viewModel.updateField('city', v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          'State / Province',
                              (v) => viewModel.updateField('stateProvince', v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          'Pincode',
                              (v) => viewModel.updateField('pincode', v),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () => viewModel.useDeviceLocation(),
                        icon: const Icon(Icons.my_location),
                        label: const Text('Get Location'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Coordinates Display
                  if (viewModel.latitude != null && viewModel.longitude != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal.shade300),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.teal.shade50,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.teal.shade600,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Coordinates',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.teal.shade600,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Lat: ${viewModel.latitude!.toStringAsFixed(6)} | Lon: ${viewModel.longitude!.toStringAsFixed(6)}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.teal.shade700,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                ],

                // Contact Information Section
                _buildSectionHeader('Contact Information'),
                const SizedBox(height: 12),
                _buildTextField(
                  'Contact Number',
                      (v) => viewModel.updateField('contactNumber', v),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  '24/7 Contact Number (if any)',
                      (v) => viewModel.updateField('contact24x7', v),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Email Address',
                      (v) => viewModel.updateField('email', v),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Operating Hours (e.g., 09:00-18:00)',
                      (v) => viewModel.updateField('operatingHours', v),
                ),
                const SizedBox(height: 24),

                // Services Section - Changed to comma-separated input
                _buildSectionHeader('Services Offered'),
                const SizedBox(height: 12),
                _buildTextField(
                  'Services (comma separated, e.g., Whole Blood, Platelets, Plasma)',
                      (v) => viewModel.updateField('servicesText', v),
                ),
                const SizedBox(height: 24),

                // Additional Options Section
                _buildSectionHeader('Additional Information'),
                const SizedBox(height: 12),
                Text(
                  'Do you organize donation camps?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Yes Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            viewModel.setOrganizesDonationCamp(true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: viewModel.organizesDonationCamp
                                  ? Colors.green.shade600
                                  : Colors.green.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: viewModel.organizesDonationCamp
                                ? Colors.green.shade100
                                : Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: viewModel.organizesDonationCamp
                                        ? Colors.green.shade600
                                        : Colors.green.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: viewModel.organizesDonationCamp
                                    ? Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green.shade600,
                                    ),
                                  ),
                                )
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Yes',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: viewModel.organizesDonationCamp
                                      ? Colors.green.shade700
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // No Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            viewModel.setOrganizesDonationCamp(false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: !viewModel.organizesDonationCamp
                                  ? Colors.red.shade600
                                  : Colors.red.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: !viewModel.organizesDonationCamp
                                ? Colors.red.shade100
                                : Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: !viewModel.organizesDonationCamp
                                        ? Colors.red.shade600
                                        : Colors.red.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: !viewModel.organizesDonationCamp
                                    ? Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red.shade600,
                                    ),
                                  ),
                                )
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'No',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: !viewModel.organizesDonationCamp
                                      ? Colors.red.shade700
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Service Area (comma separated)',
                      (v) => viewModel.updateField('serviceArea', v),
                ),
                const SizedBox(height: 28),

                // Register Button
                if (!embeddedInHospital)
                  ElevatedButton(
                    onPressed: () {
                      print('Services List: ${viewModel.services}');
                      print('Accreditations: ${viewModel.accreditations}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Register Blood Bank',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.red.shade300,
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.red.shade700,
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      Function(String) onChanged, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.shade200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.shade600, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.red.shade600),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
}