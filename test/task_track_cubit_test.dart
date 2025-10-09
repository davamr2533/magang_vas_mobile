import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vas_reporting/screen/task_track/task_track_service.dart';
import 'package:vas_reporting/screen/task_track/track_cubit/task_track_cubit.dart';

class MockTaskTrackService extends Mock implements TaskTrackService {}

void main() {
  late MockTaskTrackService mockService;
  late TaskTrackCubit cubit;

  setUp(() {
    mockService = MockTaskTrackService();
    cubit = TaskTrackCubit(mockService);
  });

  tearDown(() {
    cubit.close();
  });

  // ✅ Test 1: Loading -> Success (API return berhasil)
  blocTest<TaskTrackCubit, TaskTrackState>(
    'emits [Loading, Success] when fetchTask() returns success response',
    build: () {
      when(() => mockService.getTaskTracker()).thenAnswer(
            (_) async => {
          'status': 'success',
          'data': [
            {
              'id': 1,
              'nama_task': 'Testing Task',
              'status': 'ongoing',
            },
          ],
        },
      );
      return cubit;
    },
    act: (cubit) => cubit.fetchTask(),
    expect: () => [
      isA<TaskTrackLoading>(),
      isA<TaskTrackSuccess>(),
    ],
    verify: (_) {
      verify(() => mockService.getTaskTracker()).called(1);
    },
  );




  // ❌ Test 2: Loading -> Failure (API return gagal)
  blocTest<TaskTrackCubit, TaskTrackState>(
    'emits [Loading, Failure] when fetchTask() returns non-success response',
    build: () {
      when(() => mockService.getTaskTracker()).thenAnswer(
            (_) async => {'status': 'error', 'data': []},
      );
      return cubit;
    },
    act: (cubit) => cubit.fetchTask(),
    expect: () => [
      isA<TaskTrackLoading>(),
      isA<TaskTrackFailure>(),
    ],
  );


}
