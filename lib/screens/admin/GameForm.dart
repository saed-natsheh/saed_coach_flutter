import 'package:flutter/material.dart';
import 'package:saed_coach/models/models.dart';

class GameForm extends StatefulWidget {
  final Game? game;
  final List<Club> clubs;
  final Function(Game) onSubmit;

  const GameForm({
    super.key,
    this.game,
    required this.clubs,
    required this.onSubmit,
  });

  @override
  State<GameForm> createState() => _GameFormState();
}

class _GameFormState extends State<GameForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late String _status;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _venueNameController;
  late TextEditingController _venueAddressController;
  late TextEditingController _homeScoreController;
  late TextEditingController _awayScoreController;
  late TextEditingController _coachNotesController;
  late String _homeClubId;
  late String _awayClubId;

  // Status options with unique values
  static const List<String> _statusOptions = [
    'upcoming',
    'ongoing',
    'completed',
    'canceled',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.game?.title ?? '');
    _status = widget.game?.status ?? 'upcoming';
    _dateController = TextEditingController(
      text: widget.game?.date.toString().split(' ')[0] ?? '',
    );
    _timeController = TextEditingController(text: widget.game?.time ?? '14:00');
    _venueNameController = TextEditingController(
      text: widget.game?.venue.name ?? '',
    );
    _venueAddressController = TextEditingController(
      text: widget.game?.venue.address ?? '',
    );
    _homeScoreController = TextEditingController(
      text: widget.game?.homeScore?.toString() ?? '',
    );
    _awayScoreController = TextEditingController(
      text: widget.game?.awayScore?.toString() ?? '',
    );
    _coachNotesController = TextEditingController(
      text: widget.game?.coachNotes ?? '',
    );

    // Initialize club selections
    if (widget.clubs.isNotEmpty) {
      _homeClubId = widget.game?.homeClubId ?? widget.clubs.first.id;
      _awayClubId =
          widget.game?.awayClubId ??
          (widget.clubs.length > 1
              ? widget.clubs[1].id
              : widget.clubs.first.id);

      // Ensure home and away clubs are different
      if (_homeClubId == _awayClubId && widget.clubs.length > 1) {
        _awayClubId = widget.clubs
            .firstWhere((club) => club.id != _homeClubId)
            .id;
      }
    } else {
      _homeClubId = '';
      _awayClubId = '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _venueNameController.dispose();
    _venueAddressController.dispose();
    _homeScoreController.dispose();
    _awayScoreController.dispose();
    _coachNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Game Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              items: _statusOptions
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _status = value;
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: widget.game?.date ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _dateController.text = date.toString().split(' ')[0];
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _timeController,
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          _timeController.text =
                              '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a time';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Venue Information',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _venueNameController,
              decoration: const InputDecoration(
                labelText: 'Venue Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter venue name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _venueAddressController,
              decoration: const InputDecoration(
                labelText: 'Venue Address',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter venue address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text('Teams', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (widget.clubs.isEmpty)
              const Text(
                'No clubs available',
                style: TextStyle(color: Colors.red),
              )
            else ...[
              DropdownButtonFormField<String>(
                value: _homeClubId.isNotEmpty ? _homeClubId : null,
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
                      _homeClubId = value;
                      // Ensure home and away clubs are different
                      if (_awayClubId == value) {
                        _awayClubId = widget.clubs
                            .firstWhere((club) => club.id != value)
                            .id;
                      }
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Home Club',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select home club';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _awayClubId.isNotEmpty ? _awayClubId : null,
                items: widget.clubs
                    .where((club) => club.id != _homeClubId)
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
                      _awayClubId = value;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Away Club',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select away club';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 16),
            const Text('Score', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _homeScoreController,
                    decoration: const InputDecoration(
                      labelText: 'Home Score',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _awayScoreController,
                    decoration: const InputDecoration(
                      labelText: 'Away Score',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _coachNotesController,
              decoration: const InputDecoration(
                labelText: 'Coach Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Game'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final game = Game(
        id: widget.game?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        status: _status,
        date: DateTime.parse(_dateController.text),
        time: _timeController.text,
        venue: Venue(
          name: _venueNameController.text,
          address: _venueAddressController.text,
        ),
        homeClubId: _homeClubId,
        awayClubId: _awayClubId,
        homeScore: _homeScoreController.text.isNotEmpty
            ? int.tryParse(_homeScoreController.text)
            : null,
        awayScore: _awayScoreController.text.isNotEmpty
            ? int.tryParse(_awayScoreController.text)
            : null,
        lineup: widget.game?.lineup ?? [],
        attendance: widget.game?.attendance ?? [],
        coachNotes: _coachNotesController.text,
      );
      widget.onSubmit(game);
    }
  }
}
