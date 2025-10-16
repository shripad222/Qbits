// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:smart_blood_availability/features/auth/viewmodel/donor_form_viewmodel.dart';
// import 'package:smart_blood_availability/shared/widgets/app_dropdown.dart';
// import 'dart:io';
//
// import '../../../pages/Donor.dart';
// class DonorRegistrationForm extends ConsumerStatefulWidget {
//   const DonorRegistrationForm({super.key});
//
//   @override
//   ConsumerState<DonorRegistrationForm> createState() => _DonorRegistrationFormState();
// }
//
// class _DonorRegistrationFormState extends ConsumerState<DonorRegistrationForm> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = ref.watch(donorFormViewModelProvider.notifier);
//     final state = ref.watch(donorFormViewModelProvider);
//
//     const List<String> bloodGroups = [
//       'A+',
//       'B+',
//       'O+',
//       'AB+',
//       'A-',
//       'B-',
//       'O-',
//       'AB-',
//     ];
//
//     return SingleChildScrollView(
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.red.shade50, Colors.white],
//           ),
//         ),
//
//         child: Form(
//           key: viewModel.formKey,
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Header Section
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Colors.red.shade600, Colors.red.shade400],
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     children: [
//                       Icon(Icons.favorite, size: 40, color: Colors.white),
//                       const SizedBox(height: 12),
//                       const Text(
//                         'Become a Life Saver',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         'Join our donor community and save lives',
//                         style: TextStyle(fontSize: 14, color: Colors.white70),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 28),
//
//                 // Profile Picture Section
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.red.shade200, width: 2),
//                     borderRadius: BorderRadius.circular(12),
//                     color: Colors.red.shade50,
//                   ),
//                   child: Column(
//                     children: [
//                       if (viewModel.profileImagePath == null)
//                         Icon(
//                           Icons.person_outline,
//                           size: 50,
//                           color: Colors.red.shade300,
//                         )
//                       else
//                         SizedBox(
//                           height: 120,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.file(
//                               File(viewModel.profileImagePath!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       const SizedBox(height: 12),
//                       ElevatedButton.icon(
//                         onPressed: () => viewModel.pickImage(),
//                         icon: const Icon(Icons.camera_alt),
//                         label: const Text('Upload Profile Picture'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red.shade600,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                       if (viewModel.profileImagePath != null) ...[
//                         const SizedBox(height: 8),
//                         Text(
//                           viewModel.profileImagePath!.split('/').last,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.red.shade600,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 28),
//
//                 // Personal Information Section
//                 _buildSectionHeader('Personal Information'),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildTextField(
//                         'First Name',
//                         (val) => viewModel.updateField('firstName', val),
//                         validator: (val) => val!.isEmpty ? 'Required' : null,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _buildTextField(
//                         'Last Name',
//                         (val) => viewModel.updateField('lastName', val),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 _buildTextField(
//                   'Email Address',
//                   (val) => viewModel.updateField('emailAddress', val),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (val) => val!.isEmpty ? 'Email required' : null,
//                 ),
//                 const SizedBox(height: 12),
//                 _buildTextField(
//                   'Mobile Number',
//                   (val) => viewModel.updateField('mobileNumber', val),
//                   keyboardType: TextInputType.phone,
//                 ),
//                 const SizedBox(height: 12),
//                 _buildTextField(
//                   'Password',
//                   (val) => viewModel.updateField('password', val),
//                   obscureText: true,
//                   validator: (val) =>
//                       val!.length < 6 ? 'At least 6 characters' : null,
//                 ),
//                 const SizedBox(height: 28),
//
//                 // Health Information Section
//                 _buildSectionHeader('Health Information'),
//                 const SizedBox(height: 12),
//                 _buildDateField(
//                   'Date of Birth',
//                   viewModel.dobController,
//                   () async {
//                     final picked = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now().subtract(
//                         const Duration(days: 365 * 18),
//                       ),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime.now(),
//                     );
//                     if (picked != null)
//                       viewModel.updateField('dateOfBirth', picked);
//                   },
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildBloodGroupDropdown(bloodGroups, (val) {
//                         if (val != null)
//                           viewModel.updateField('bloodGroup', val);
//                       }),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _buildTextField(
//                         'Weight (kg)',
//                         (val) => viewModel.updateField('weight', val),
//                         keyboardType: TextInputType.number,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 _buildDateField(
//                   'Last Donation Date',
//                   viewModel.lastDonationController,
//                   () async {
//                     final picked = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime.now(),
//                     );
//                     if (picked != null)
//                       viewModel.updateField('dateOfLastDonation', picked);
//                   },
//                 ),
//                 const SizedBox(height: 28),
//
//                 // Location Section
//                 _buildSectionHeader('Location Information'),
//                 const SizedBox(height: 12),
//                 _buildTextField(
//                   'Street Address',
//                   (val) => viewModel.updateField('location', val),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildTextField(
//                         'City',
//                         (val) => viewModel.updateField('city', val),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _buildTextField(
//                         'State / Province',
//                         (val) => viewModel.updateField('stateProvince', val),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 _buildTextField(
//                   'Pincode',
//                   (val) => viewModel.updateField('pincode', val),
//                   keyboardType: TextInputType.number,
//                   controller: viewModel.pincodeController,
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         onPressed: () =>
//                             viewModel.fetchCoordinatesFromAddress(),
//                         icon: const Icon(Icons.location_searching),
//                         label: const Text('Find Coordinates'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue.shade600,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         onPressed: () => viewModel.useDeviceLocation(),
//                         icon: const Icon(Icons.my_location),
//                         label: const Text('Current Location'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue.shade600,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (viewModel.coordinates != null) ...[
//                   const SizedBox(height: 12),
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade50,
//                       border: Border.all(color: Colors.blue.shade200),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       'Coordinates: ${viewModel.coordinates!.latitude.toStringAsFixed(6)}, ${viewModel.coordinates!.longitude.toStringAsFixed(6)}',
//                       style: TextStyle(
//                         color: Colors.blue.shade700,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//                 const SizedBox(height: 28),
//
//                 // Health Screening Section
//                 _buildSectionHeader('Health Screening'),
//                 const SizedBox(height: 12),
//                 _buildHealthCheckbox('chronic_conditions', 'Any chronic medical conditions? (e.g., diabetes, hypertension)'),
//                 _buildHealthCheckbox('on_regular_medication', 'Currently on regular medication?'),
//                 _buildHealthCheckbox('history_of_transfusion', 'Ever received a blood transfusion?'),
//                 _buildHealthCheckbox('chronic_infectious_disease', 'Any chronic infectious disease? (e.g., hepatitis, HIV)'),
//                 _buildHealthCheckbox('major_surgery_history', 'Had major surgery in the past year?'),
//
//
//                 const SizedBox(height: 28),
//
//                 // Submit Button
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => LandingPage()),
//                     );
//                   },
//                   // state.isLoading ? null : viewModel.registerDonor,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red.shade600,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     disabledBackgroundColor: Colors.grey.shade400,
//                   ),
//                   child: state.isLoading
//                       ? const SizedBox(
//                           width: 24,
//                           height: 24,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Colors.white,
//                             ),
//                           ),
//                         )
//                       : const Text(
//                           'Register as Donor',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                 ),
//
//                 // Error Display
//                 if (state.hasError)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16.0),
//                     child: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.red.shade50,
//                         border: Border.all(color: Colors.red.shade300),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(Icons.error_outline, color: Colors.red.shade600),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               'Registration Failed: ${state.error}',
//                               style: TextStyle(
//                                 color: Colors.red.shade600,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(String title) {
//     return Container(
//       padding: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Colors.red.shade300, width: 2),
//         ),
//       ),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Colors.red.shade700,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(
//     String label,
//     Function(String) onChanged, {
//     TextInputType keyboardType = TextInputType.text,
//     bool obscureText = false,
//     TextEditingController? controller,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: Colors.red.shade200),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: Colors.red.shade200, width: 1.5),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: Colors.red.shade600, width: 2),
//         ),
//         filled: true,
//         fillColor: Colors.white,
//         labelStyle: TextStyle(color: Colors.red.shade600),
//       ),
//       keyboardType: keyboardType,
//       obscureText: obscureText,
//       onChanged: onChanged,
//       validator: validator,
//     );
//   }
//
//   Widget _buildDateField(
//     String label,
//     TextEditingController controller,
//     Future<void> Function() onTap,
//   ) {
//     return TextFormField(
//       readOnly: true,
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: Colors.red.shade200),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: Colors.red.shade200, width: 1.5),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: Colors.red.shade600, width: 2),
//         ),
//         filled: true,
//         fillColor: Colors.white,
//         labelStyle: TextStyle(color: Colors.red.shade600),
//         suffixIcon: Icon(Icons.calendar_today, color: Colors.red.shade600),
//       ),
//       onTap: onTap,
//     );
//   }
//
//   Widget _buildBloodGroupDropdown(
//     List<String> bloodGroups,
//     void Function(String?) onChanged,
//   ) {
//     return AppDropdown<String>(
//       labelText: 'Blood Group',
//       value: null,
//       items: bloodGroups,
//       itemLabelMapper: (group) => group,
//       onChanged: onChanged, // now matches ValueChanged<String?>
//     );
//   }
//   Widget _buildHealthCheckbox(String key, String label) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.red.shade100),
//       ),
//       child: StatefulBuilder(
//         builder: (context, setState) {
//           final viewModel = ref.read(donorFormViewModelProvider.notifier);
//           final checked = viewModel.healthScreening[key] ?? false;
//
//           return CheckboxListTile(
//             value: checked,
//             onChanged: (v) {
//               viewModel.updateHealthScreening(key, v ?? false);
//               setState(() {}); // Force local rebuild
//             },
//             activeColor: Colors.red.shade600,
//             title: Text(label, style: const TextStyle(fontSize: 14)),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           );
//         },
//       ),
//     );
//   }
//
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_blood_availability/features/auth/viewmodel/donor_form_viewmodel.dart';
import 'package:smart_blood_availability/shared/widgets/app_dropdown.dart';
import 'dart:io';
import '../../../pages/Donor.dart';

class DonorRegistrationForm extends ConsumerStatefulWidget {
  const DonorRegistrationForm({super.key});

  @override
  ConsumerState<DonorRegistrationForm> createState() =>
      _DonorRegistrationFormState();
}

class _DonorRegistrationFormState extends ConsumerState<DonorRegistrationForm> {
  @override
  Widget build(BuildContext context) {
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

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade50, Colors.white],
          ),
        ),
        child: Form(
          key: viewModel.formKey,
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
                      colors: [Colors.red.shade600, Colors.red.shade400],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.favorite, size: 40, color: Colors.white),
                      const SizedBox(height: 12),
                      const Text(
                        'Become a Life Saver',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Join our donor community and save lives',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Profile Picture Section - With Consumer
                Consumer(
                  builder: (context, ref, _) {
                    final vm = ref.watch(donorFormViewModelProvider.notifier);
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red.shade200, width: 2),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.red.shade50,
                      ),
                      child: Column(
                        children: [
                          if (vm.profileImagePath == null)
                            Icon(
                              Icons.person_outline,
                              size: 50,
                              color: Colors.red.shade300,
                            )
                          else
                            SizedBox(
                              height: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(vm.profileImagePath!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () => vm.pickImage(),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Upload Profile Picture'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          if (vm.profileImagePath != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              vm.profileImagePath!.split('/').last,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),

                // Personal Information Section
                _buildSectionHeader('Personal Information'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        'First Name',
                            (val) => viewModel.updateField('firstName', val),
                        validator: (val) => val!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        'Last Name',
                            (val) => viewModel.updateField('lastName', val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Email Address',
                      (val) => viewModel.updateField('emailAddress', val),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val!.isEmpty ? 'Email required' : null,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Mobile Number',
                      (val) => viewModel.updateField('mobileNumber', val),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Password',
                      (val) => viewModel.updateField('password', val),
                  obscureText: true,
                  validator: (val) =>
                  val!.length < 6 ? 'At least 6 characters' : null,
                ),
                const SizedBox(height: 28),

                // Health Information Section
                _buildSectionHeader('Health Information'),
                const SizedBox(height: 12),
                _buildDateField(
                  'Date of Birth',
                  viewModel.dobController,
                      () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(
                        const Duration(days: 365 * 18),
                      ),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      viewModel.updateField('dateOfBirth', picked);
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildBloodGroupDropdown(bloodGroups, (val) {
                        if (val != null)
                          viewModel.updateField('bloodGroup', val);
                      }),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        'Weight (kg)',
                            (val) => viewModel.updateField('weight', val),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDateField(
                  'Last Donation Date',
                  viewModel.lastDonationController,
                      () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      viewModel.updateField('dateOfLastDonation', picked);
                    }
                  },
                ),
                const SizedBox(height: 28),

                // Location Section
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
                          backgroundColor: Colors.blue.shade600,
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
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Consumer(
                  builder: (context, ref, _) {
                    final vm = ref.watch(donorFormViewModelProvider.notifier);
                    return vm.coordinates != null
                        ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Coordinates: ${vm.coordinates!.latitude.toStringAsFixed(6)}, ${vm.coordinates!.longitude.toStringAsFixed(6)}',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                        : const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 28),

                // Health Screening Section
                _buildSectionHeader('Health Screening'),
                const SizedBox(height: 12),
                _buildHealthCheckbox(
                    'chronic_conditions',
                    'Any chronic medical conditions? (e.g., diabetes, hypertension)'),
                _buildHealthCheckbox(
                    'on_regular_medication', 'Currently on regular medication?'),
                _buildHealthCheckbox('history_of_transfusion',
                    'Ever received a blood transfusion?'),
                _buildHealthCheckbox(
                    'chronic_infectious_disease',
                    'Any chronic infectious disease? (e.g., hepatitis, HIV)'),
                _buildHealthCheckbox('major_surgery_history',
                    'Had major surgery in the past year?'),
                const SizedBox(height: 28),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LandingPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                      : const Text(
                    'Register as Donor',
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
                          Icon(Icons.error_outline, color: Colors.red.shade600),
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
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.red.shade300, width: 2),
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
        bool obscureText = false,
        TextEditingController? controller,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
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
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildDateField(
      String label,
      TextEditingController controller,
      Future<void> Function() onTap,
      ) {
    return TextFormField(
      readOnly: true,
      controller: controller,
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
        suffixIcon: Icon(Icons.calendar_today, color: Colors.red.shade600),
      ),
      onTap: onTap,
    );
  }

  Widget _buildBloodGroupDropdown(
      List<String> bloodGroups,
      void Function(String?) onChanged,
      ) {
    return AppDropdown<String>(
      labelText: 'Blood Group',
      value: null,
      items: bloodGroups,
      itemLabelMapper: (group) => group,
      onChanged: onChanged,
    );
  }

  Widget _buildHealthCheckbox(String key, String label) {
    return Consumer(
      builder: (context, ref, _) {
        final vm = ref.watch(donorFormViewModelProvider.notifier);
        final checked = vm.healthScreening[key] ?? false;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red.shade100),
          ),
          child: CheckboxListTile(
            value: checked,
            onChanged: (v) {
              vm.updateHealthScreening(key, v ?? false);
            },
            activeColor: Colors.red.shade600,
            title: Text(label, style: const TextStyle(fontSize: 14)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}