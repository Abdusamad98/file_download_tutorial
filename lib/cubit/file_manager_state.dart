part of 'file_manager_cubit.dart';

class FileManagerState extends Equatable {
  FileManagerState({
    required this.files,
    required this.progresses,
  });

  final List<FileInfo> files;
  final List<double> progresses;

  FileManagerState copyWith({
    List<FileInfo>? files,
    List<double>? progresses,
  }) =>
      FileManagerState(
        files: files ?? this.files,
        progresses: progresses ?? this.progresses,
      );

  @override
  List<Object?> get props => [
        files,
        progresses,
      ];
}
