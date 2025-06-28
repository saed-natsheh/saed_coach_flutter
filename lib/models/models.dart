class Venue {
  final String name;
  final String address;

  Venue({required this.name, required this.address});

  Map<String, dynamic> toMap() {
    return {'name': name, 'address': address};
  }

  factory Venue.fromMap(Map<String, dynamic> map) {
    return Venue(name: map['name'] ?? '', address: map['address'] ?? '');
  }
}

class Club {
  final String id;
  final String name;
  final String description;
  final String logoUrl;
  final String address;
  final String phone;
  final List<String> playerIds;

  Club({
    required this.id,
    required this.name,
    required this.description,
    this.logoUrl = '',
    required this.address,
    required this.phone,
    this.playerIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'address': address,
      'phone': phone,
      'playerIds': playerIds,
    };
  }

  factory Club.fromMap(String id, Map<String, dynamic> map) {
    return Club(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      playerIds: List<String>.from(map['playerIds'] ?? []),
    );
  }
}

class Player {
  final String id;
  final String name;
  final String position;
  final int number;
  final String clubId;
  final DateTime birthDate;
  final String photoUrl;

  Player({
    required this.id,
    required this.name,
    required this.position,
    required this.number,
    required this.clubId,
    required this.birthDate,
    this.photoUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'number': number,
      'clubId': clubId,
      'birthDate': birthDate.toIso8601String(),
      'photoUrl': photoUrl,
    };
  }

  factory Player.fromMap(String id, Map<String, dynamic> map) {
    return Player(
      id: id,
      name: map['name'] ?? '',
      position: map['position'] ?? '',
      number: map['number']?.toInt() ?? 0,
      clubId: map['clubId'] ?? '',
      birthDate: DateTime.parse(map['birthDate']),
      photoUrl: map['photoUrl'] ?? '',
    );
  }
}

// Update Game model to include clubs and scores
class Game {
  final String id;
  final String title;
  final String status;
  final DateTime date;
  final String time;
  final Venue venue;
  final String homeClubId;
  final String awayClubId;
  final int? homeScore;
  final int? awayScore;
  final List<String> lineup;
  final List<String> attendance;
  final String coachNotes;

  Game({
    required this.id,
    required this.title,
    required this.status,
    required this.date,
    required this.time,
    required this.venue,
    required this.homeClubId,
    required this.awayClubId,
    this.homeScore,
    this.awayScore,
    this.lineup = const [],
    this.attendance = const [],
    required this.coachNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'status': status,
      'date': date.toIso8601String(),
      'time': time,
      'venue': venue.toMap(),
      'homeClubId': homeClubId,
      'awayClubId': awayClubId,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'lineup': lineup,
      'attendance': attendance,
      'coachNotes': coachNotes,
    };
  }

  factory Game.fromMap(String id, Map<String, dynamic> map) {
    return Game(
      id: id,
      title: map['title'] ?? '',
      status: map['status'] ?? '',
      date: DateTime.parse(map['date']),
      time: map['time'] ?? '',
      venue: Venue.fromMap(map['venue'] ?? {}),
      homeClubId: map['homeClubId'] ?? '',
      awayClubId: map['awayClubId'] ?? '',
      homeScore: map['homeScore']?.toInt(),
      awayScore: map['awayScore']?.toInt(),
      lineup: List<String>.from(map['lineup'] ?? []),
      attendance: List<String>.from(map['attendance'] ?? []),
      coachNotes: map['coachNotes'] ?? '',
    );
  }
}
