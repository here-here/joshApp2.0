import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CheckinEvent extends Equatable {
  const CheckinEvent();
}

class CheckinButtonPressed extends CheckinEvent {
  final String pid;
  final String classid;

  const CheckinButtonPressed({
    @required this.pid,
    @required this.classid,
  });

  @override
  List<Object> get props => [pid, classid];

  @override
  String toString() =>
      'CheckinButtonPressed { pid: $pid, classid: $classid }';
}
