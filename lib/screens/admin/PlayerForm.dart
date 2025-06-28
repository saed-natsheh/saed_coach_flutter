import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saed_coach/models/models.dart';

class PlayerForm extends StatefulWidget {
  final Player? player;
  final Function(Player) onSubmit;
  final List<Club> clubs;

  const PlayerForm({
    super.key,
    this.player,
    required this.onSubmit,
    required this.clubs,
  });

  @override
  State<PlayerForm> createState() => _PlayerFormState();
}

class _PlayerFormState extends State<PlayerForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _positionController;
  late TextEditingController _numberController;
  late String _clubId;
  late TextEditingController _birthDateController;
  String _photoUrl = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.player?.name ?? '');
    _positionController = TextEditingController(
      text: widget.player?.position ?? '',
    );
    _numberController = TextEditingController(
      text: widget.player?.number.toString() ?? '',
    );
    _clubId = widget.player?.clubId ?? widget.clubs.first.id;
    _birthDateController = TextEditingController(
      text: widget.player?.birthDate.toString().split(' ')[0] ?? '',
    );
    _photoUrl = widget.player?.photoUrl ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _numberController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Upload to Firebase Storage and get URL
      setState(() {
        _photoUrl = pickedFile.path;
      });
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
                backgroundImage: _photoUrl.isNotEmpty
                    ? NetworkImage(_photoUrl)
                    : const AssetImage('assets/default_player.jpg')
                          as ImageProvider,
                child: _photoUrl.isEmpty
                    ? const Icon(Icons.add_a_photo, size: 30)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter player name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _positionController,
              decoration: const InputDecoration(labelText: 'Position'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter position';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _numberController,
              decoration: const InputDecoration(labelText: 'Jersey Number'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter jersey number';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _clubId,
              items: widget.clubs
                  .map(
                    (club) => DropdownMenuItem(
                      value: club.id,
                      child: Text(club.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _clubId = value;
                  });
                }
              },
              decoration: const InputDecoration(labelText: 'Club'),
            ),
            TextFormField(
              controller: _birthDateController,
              decoration: const InputDecoration(
                labelText: 'Birth Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: widget.player?.birthDate ?? DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  _birthDateController.text = date.toString().split(' ')[0];
                }
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
      final player = Player(
        id:
            widget.player?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        position: _positionController.text,
        number: int.parse(_numberController.text),
        clubId: _clubId,
        birthDate: DateTime.parse(_birthDateController.text),
        photoUrl: _photoUrl,
      );
      widget.onSubmit(player);
    }
  }
}
