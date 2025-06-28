import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:saed_coach/models/models.dart';

class ClubForm extends StatefulWidget {
  final Club? club;
  final Function(Club) onSubmit;
  final Function()? onImagePick;

  const ClubForm({
    super.key,
    this.club,
    required this.onSubmit,
    this.onImagePick,
  });

  @override
  State<ClubForm> createState() => _ClubFormState();
}

class _ClubFormState extends State<ClubForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  String _logoUrl = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.club?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.club?.description ?? '',
    );
    _addressController = TextEditingController(
      text: widget.club?.address ?? '',
    );
    _phoneController = TextEditingController(text: widget.club?.phone ?? '');
    _logoUrl = widget.club?.logoUrl ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Here you would upload the image to Firebase Storage
      // and get the download URL
      // For now, we'll just use the file path
      setState(() {
        _logoUrl = pickedFile.path;
      });
      widget.onImagePick?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _logoUrl.isNotEmpty
                    ? NetworkImage(_logoUrl)
                    : const AssetImage('assets/default_club.png')
                          as ImageProvider,
                child: _logoUrl.isEmpty
                    ? const Icon(Icons.add_a_photo, size: 30)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Club Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter club name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter address';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _submitForm, child: const Text('Save')),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final club = Club(
        id: widget.club?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        logoUrl: _logoUrl,
        address: _addressController.text,
        phone: _phoneController.text,
        playerIds: widget.club?.playerIds ?? [],
      );
      widget.onSubmit(club);
    }
  }
}
