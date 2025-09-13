import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:unite/core/models/app_user.dart';
import 'package:unite/core/data/repositories/event_repository.dart';
import 'package:unite/core/data/repositories/user_repository.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/features/organizer/models/ticket.dart';
import 'package:unite/features/organizer/models/zone.dart';
import 'package:unite/features/organizer/models/track.dart';
import 'package:unite/features/organizer/models/session.dart';
import 'package:unite/features/organizer/models/stall.dart';

class ManageEventNotifier extends ChangeNotifier {
  final EventRepository _eventRepository;
  final UserRepository _userRepository;

  ManageEventNotifier({
    required EventRepository eventRepository,
    required UserRepository userRepository,
  }) : _eventRepository = eventRepository,
       _userRepository = userRepository;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  Event? _event;
  Event? get event => _event;

  List<AppUser> _moderators = [];
  List<AppUser> get moderators => _moderators;

  String? _error;
  String? get error => _error;

  File? _pickedImage;
  File? get pickedImage => _pickedImage;

  Future<void> loadEvent(String eventId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      _event = await _eventRepository.fetchEvent(eventId);
      await _fetchModeratorDetails();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEventDetails({
    required String title,
    required String organizerContact,
    required String venue,
    required String description,
    required int totalSeats,
  }) async {
    if (_event == null) return;
    _event!.title = title;
    _event!.organizerContact = organizerContact;
    _event!.venue = venue;
    _event!.description = description;
    _event!.totalSeats = totalSeats;
    notifyListeners();
  }

  void setDates({DateTime? start, DateTime? end}) {
    if (start != null) _event?.startDate = start;
    if (end != null) _event?.endDate = end;
    notifyListeners();
  }

  void setPickedImage(File? image, {String? webPath}) {
    _pickedImage = image;
    if (kIsWeb && webPath != null) {
      _event?.imageUrl = webPath;
    } else {
      _event?.imageUrl =
          'https://images.unsplash.com/photo-1601323685954-d6215777d853?auto=format&fit=crop';
    }
    notifyListeners();
  }

  Future<void> addModerator(AppUser user) async {
    if (_event != null && !_event!.moderatorUids.contains(user.uid)) {
      _event!.moderatorUids.add(user.uid);
      await _fetchModeratorDetails();
      await updateEvent();
    }
  }

  Future<void> removeModerator(String uid) async {
    if (_event != null) {
      _event!.moderatorUids.remove(uid);
      await _fetchModeratorDetails();
      await updateEvent();
    }
  }

  // Methods for Zones, Tracks
  void addZone(Zone zone) {
    _event?.zones.add(zone);
    updateAndNotify();
  }

  void removeZone(Zone zone) {
    _event?.zones.remove(zone);
    updateAndNotify();
  }

  void addTrack(Zone zone, Track track) {
    zone.tracks.add(track);
    updateAndNotify();
  }

  void removeTrack(Zone zone, Track track) {
    zone.tracks.remove(track);
    updateAndNotify();
  }

  void addSession(Track track, Session session) {
    track.sessions.add(session);
    updateAndNotify();
  }

  void removeSession(Track track, Session session) {
    track.sessions.remove(session);
    updateAndNotify();
  }

  void addStall(Track track, Stall stall) {
    track.stalls.add(stall);
    updateAndNotify();
  }

  void removeStall(Track track, Stall stall) {
    track.stalls.remove(stall);
    updateAndNotify();
  }

  void addTicket(Ticket ticket) {
    _event?.ticketTypes.add(ticket);
    updateAndNotify();
  }

  void removeTicket(Ticket ticket) {
    _event?.ticketTypes.remove(ticket);
    updateAndNotify();
  }

  void updateAndNotify() {
    notifyListeners();
    updateEvent();
  }

  Future<void> updateEvent({bool publish = false}) async {
    if (_event == null) return;

    _isSaving = true;
    notifyListeners();

    if (publish) {
      _event!.status = 'published';
    }

    try {
      await _eventRepository.updateEvent(_event!);
    } catch (e) {
      debugPrint('!!!!!!!! ERROR SAVING EVENT: ${e.toString()} !!!!!!!!');
      _error = e.toString();
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<List<AppUser>> searchUsers(String query) {
    return _userRepository.searchUsersByName(query);
  }

  Future<void> _fetchModeratorDetails() async {
    if (_event == null || _event!.moderatorUids.isEmpty) {
      _moderators = [];
      return;
    }
    _moderators = await _userRepository.fetchUsersByIds(_event!.moderatorUids);
  }
}
