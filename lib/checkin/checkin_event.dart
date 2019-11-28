import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CheckinEvent extends Equatable {
  const CheckinEvent();
}

class CheckinButtonPressed extends CheckinEvent {
  final String pid;
  final String class_name;

  const CheckinButtonPressed({
    @required this.pid,
    @required this.class_name,
  });

  @override
  List<Object> get props => [pid, class_name];

  @override
  String toString() =>
      'CheckinButtonPressed { pid: $pid, class_name: $class_name }';
}
