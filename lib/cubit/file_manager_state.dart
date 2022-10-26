part of 'file_manager_cubit.dart';

class FileManagerState extends Equatable {
  FileManagerState({
    required this.progress,
    required this.myStream,
  });

  final double progress;
  final StreamController<double> myStream;

  FileManagerState copyWith({
    double? progress,
    StreamController<double>? myStream,
  }) =>
      FileManagerState(
        progress: progress ?? this.progress,
        myStream: myStream ?? this.myStream,
      );

  @override
  List<Object?> get props => [progress, myStream];
}
