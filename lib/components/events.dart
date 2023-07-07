part of affogato.components;

enum EventType {
  spawnCursorReplacement,
  spawnCursorNew,
}

class Events {
  static final CursorEvents cursor = CursorEvents();
}

class EventPublisher {
  final Map<Function, List<Function>> listeners = {};

  Iterable<T> getCallbacksFor<T extends Function>(Function x) {
    return listeners[x]?.whereType<T>() ?? [];
  }

  bool registerListenerFor<T extends Function>(Function channel, T fn) {
    if (listeners.containsKey(channel)) {
      listeners[channel]!.add(fn);
      return true;
    } else {
      return false;
    }
  }
}

typedef SpawnCursorReplacementCallback = VoidCallback;
typedef SpawnCursorNewCallback = void Function(Cursor);

class CursorEvents extends EventPublisher {
  CursorEvents() {
    listeners.addAll({
      spawnCursorNew: [],
      spawnCursorReplacement: [],
    });
  }

  void spawnCursorReplacement() {
    for (SpawnCursorReplacementCallback callback
        in getCallbacksFor<SpawnCursorReplacementCallback>(
            spawnCursorReplacement)) {
      callback();
    }
  }

  void spawnCursorNew(Cursor newCursor) {
    for (SpawnCursorNewCallback callback
        in getCallbacksFor<SpawnCursorNewCallback>(spawnCursorNew)) {
      callback(newCursor);
    }
  }
}
