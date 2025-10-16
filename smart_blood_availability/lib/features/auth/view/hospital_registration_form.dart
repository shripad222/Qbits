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
    final internalBBStatus = state.value ?? false;

    const List<String> hospitalTypes = ['Government', 'Private'];

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade500],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.local_hospital,
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Hospital Registration',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Join the healthcare network',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Hospital Image Section
              Consumer(
                builder: (context, ref, _) {
                  final vm = ref.watch(hospitalFormViewModelProvider.notifier);
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue.shade200,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue.shade50,
                    ),
                    child: Column(
                      children: [
                        if (vm.hospitalImagePath == null)
                          Icon(
                            Icons.image_outlined,
                            size: 50,
                            color: Colors.blue.shade300,
                          )
                        else
                          SizedBox(
                            height: 140,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(vm.hospitalImagePath!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => vm.pickImage(),
                          icon: const Icon(Icons.photo_camera),
                          label: const Text('Upload Hospital Image'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        if (vm.hospitalImagePath != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            vm.hospitalImagePath!.split('/').last,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),

              // Hospital Image Preview after successful submission
              if (viewModel.hospitalImagePath != null && viewModel.hasSubmitted) ...[
                const SizedBox(height: 16),
                Text(
                  'Uploaded Hospital Image Preview:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 140,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(viewModel.hospitalImagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              const SizedBox(height: 28),

              // Basic Information Section
              _buildSectionHeader('Basic Information'),
              const SizedBox(height: 12),
              _buildTextField(
                'Name of Hospital',
                    (val) => viewModel.updateField('name', val),
                validator: (val) =>
                val!.isEmpty ? 'Hospital name required' : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                'License Number',
                    (val) => viewModel.updateField('licenseNumber', val),
                validator: (val) =>
                val!.isEmpty ? 'License number required' : null,
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                'Hospital Type',
                hospitalTypes,
                    (val) => viewModel.updateField('type', val),
              ),
              const SizedBox(height: 28),

              // Registration Document Section
              _buildSectionHeader('Registration Document'),
              const SizedBox(height: 12),
              Consumer(
                builder: (context, ref, _) {
                  final vm = ref.watch(hospitalFormViewModelProvider.notifier);
                  return Container(
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
                          onPressed: () => vm.pickPdf(),
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
                        if (vm.registrationPdfPath != null) ...[
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
                                    vm.registrationPdfPath!.split('/').last,
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
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () =>
                                OpenFile.open(vm.registrationPdfPath),
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Open PDF'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),

              // Location Information Section
              _buildSectionHeader('Location Information'),
              const SizedBox(height: 12),
              _buildTextField(
                'Street Address',
                    (val) => viewModel.updateField('location', val),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'City',
                          (val) => viewModel.updateField('city', val),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      'State / Province',
                          (val) => viewModel.updateField('stateProvince', val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildTextField(
                'Pincode',
                    (val) => viewModel.updateField('pincode', val),
                keyboardType: TextInputType.number,
                controller: viewModel.pincodeController,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          viewModel.fetchCoordinatesFromAddress(),
                      icon: const Icon(Icons.location_searching),
                      label: const Text('Find Coordinates'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => viewModel.useDeviceLocation(),
                      icon: const Icon(Icons.my_location),
                      label: const Text('Current Location'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (viewModel.coordinates != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    border: Border.all(color: Colors.teal.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Coordinates: ${viewModel.coordinates!.latitude.toStringAsFixed(6)}, ${viewModel.coordinates!.longitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 28),

              // Blood Bank Section
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
                child: Row(
                  children: [
                    Checkbox(
                      value: internalBBStatus,
                      onChanged: viewModel.toggleInternalBloodBank,
                      activeColor: Colors.red.shade600,
                    ),
                    Expanded(
                      child: Text(
                        'Internal Blood Bank Available',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                    Icon(
                      internalBBStatus
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: Colors.red.shade600,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Conditional Blood Bank form
              if (internalBBStatus) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.red.shade50,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Blood Bank Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const BloodBankRegistrationForm(
                        embeddedInHospital: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
              ],

              // Submit Button
              ElevatedButton(
                onPressed:
                state.isLoading ? null : viewModel.registerHospital,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey.shade400,
                ),
                child: state.isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  'Register Hospital',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // Error Display
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade600,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Registration Failed: ${state.error}',
                            style: TextStyle(
                              color: Colors.red.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
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
            color: Colors.blue.shade300,
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged,
      {TextInputType keyboardType = TextInputType.text,
        TextEditingController? controller,
        String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.blue.shade600),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildDropdown(String label, List<String> items,
      void Function(String?) onChanged) {
    return AppDropdown<String>(
      labelText: label,
      value: null,
      items: items,
      itemLabelMapper: (item) => item,
      onChanged: onChanged,
    );
  }
}