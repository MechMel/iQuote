class M2Event {
  List<Function> listeners;

  M2Event() {
    listeners = List();
  }

  void addListener(Function listener) {
    listeners.add(listener);
  }

  void removeListener(Function listener) {
    listeners.remove(listener);
  }

  void trigger() {
    for (Function listener in listeners) {
      listener();
    }
  }
}