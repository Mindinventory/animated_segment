import 'dart:async';

abstract class BusEvent {}

abstract class EventBus {
  void sendEvent(BusEvent event);
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

class ItemClickBusEvent extends BusEvent {
  ItemClickBusEvent({required this.index});
  final int index;
}
