part of affogato.core;

class AffogatoEvents {
  static final StreamController<AffogatoEvent> streamController =
      StreamController.broadcast();

  static final Stream<AffogatoEvent> stream = streamController.stream;
}

class AffogatoEvent {
  const AffogatoEvent();
}

class AFCursorEvent extends AffogatoEvent {
  const AFCursorEvent();
}

class AFCursorPauseBlinking extends AFCursorEvent {
  const AFCursorPauseBlinking();
}

class AFCursorResumeBlinking extends AFCursorEvent {
  const AFCursorResumeBlinking();
}
