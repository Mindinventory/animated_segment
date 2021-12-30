import 'dart:async';

/// We have created [EventBus] to manage global event easily.
abstract class BusEvent {}

abstract class EventBus {
  // this method is use to send an event.
  void sendEvent(BusEvent event);
  // this stream is use to listen and send the event.
  Stream get stream;
}

class EventBusImpl extends EventBus {
  StreamController controller = StreamController<BusEvent>();

  @override
  Stream get stream => controller.stream;

  @override
  void sendEvent(BusEvent event) {
    controller.add(event);
  }
}

/// This event will fires when on tap clicks.
class ItemClickBusEvent extends BusEvent {
  ItemClickBusEvent({required this.index});
  final int index;
}
