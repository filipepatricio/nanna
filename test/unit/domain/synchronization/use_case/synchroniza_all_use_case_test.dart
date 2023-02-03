import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable_group.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/synchronize_all_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';

void main() {
  late List<SynchronizableGroup> groups;
  late MockSaveSynchronizableItemUseCase saveSynchronizableItemUseCase;
  late SynchronizeAllUseCase useCase;

  setUp(() {
    groups = [
      SynchronizableGroup<A>(MockSynchronizableRepository(), MockSynchronizeWithRemoteUsecase()),
      SynchronizableGroup<B>(MockSynchronizableRepository(), null),
      SynchronizableGroup<C>(MockSynchronizableRepository(), MockSynchronizeWithRemoteUsecase()),
    ];
    saveSynchronizableItemUseCase = MockSaveSynchronizableItemUseCase();
    useCase = SynchronizeAllUseCase(groups, saveSynchronizableItemUseCase);
  });

  test('should call synchronizeWithRemote for each unsynchronized element', () async {
    final allSynchronizableA = [
      FakeNotSynchronized<A>(),
      FakeSynchronizedExpired<A>(),
    ];
    final allSynchronizableB = [
      FakeSynchronized<B>(),
      FakeNotSynchronized<B>(),
    ];
    final allSynchronizableC = [
      FakeNotSynchronized<C>(),
      FakeNotSynchronized<C>(),
    ];

    final aGroup = groups[0] as SynchronizableGroup<A>;
    when(aGroup.repository.getAllIds()).thenAnswer((realInvocation) async => ['a1', 'a2']);
    when(aGroup.repository.load('a1')).thenAnswer((realInvocation) async => allSynchronizableA[0]);
    when(aGroup.repository.load('a2')).thenAnswer((realInvocation) async => allSynchronizableA[1]);

    final bGroup = groups[1] as SynchronizableGroup<B>;
    when(bGroup.repository.getAllIds()).thenAnswer((realInvocation) async => ['b1', 'b2']);
    when(bGroup.repository.load('b1')).thenAnswer((realInvocation) async => allSynchronizableB[0]);
    when(bGroup.repository.load('b2')).thenAnswer((realInvocation) async => allSynchronizableB[1]);

    final cGroup = groups[2] as SynchronizableGroup<C>;
    when(cGroup.repository.getAllIds()).thenAnswer((realInvocation) async => ['c1', 'c2']);
    when(cGroup.repository.load('c1')).thenAnswer((realInvocation) async => allSynchronizableC[0]);
    when(cGroup.repository.load('c2')).thenAnswer((realInvocation) async => allSynchronizableC[1]);

    await useCase();

    verify(aGroup.synchronizeWithRemoteUseCase!.call(allSynchronizableA[0])).called(1);
    verify(cGroup.synchronizeWithRemoteUseCase!.call(allSynchronizableC[0])).called(1);
    verify(cGroup.synchronizeWithRemoteUseCase!.call(allSynchronizableC[1])).called(1);
  });

  test('should delete all expired elements', () async {
    final allSynchronizableA = [
      FakeSynchronizedExpired<A>(),
      FakeNotSynchronized<A>(),
      FakeSynchronizedExpired<A>(),
    ];
    final allSynchronizableB = [
      FakeSynchronized<B>(),
      FakeSynchronizedExpired<B>(),
    ];
    final allSynchronizableC = [
      FakeNotSynchronized<C>(),
      FakeNotSynchronized<C>(),
    ];

    final aGroup = groups[0] as SynchronizableGroup<A>;
    when(aGroup.repository.getAllIds()).thenAnswer((realInvocation) async => ['a1', 'a2', 'a3']);
    when(aGroup.repository.load('a1')).thenAnswer((realInvocation) async => allSynchronizableA[0]);
    when(aGroup.repository.load('a2')).thenAnswer((realInvocation) async => allSynchronizableA[1]);
    when(aGroup.repository.load('a3')).thenAnswer((realInvocation) async => allSynchronizableA[2]);

    final bGroup = groups[1] as SynchronizableGroup<B>;
    when(bGroup.repository.getAllIds()).thenAnswer((realInvocation) async => ['b1', 'b2']);
    when(bGroup.repository.load('b1')).thenAnswer((realInvocation) async => allSynchronizableB[0]);
    when(bGroup.repository.load('b2')).thenAnswer((realInvocation) async => allSynchronizableB[1]);

    final cGroup = groups[2] as SynchronizableGroup<C>;
    when(cGroup.repository.getAllIds()).thenAnswer((realInvocation) async => ['c1', 'c2']);
    when(cGroup.repository.load('c1')).thenAnswer((realInvocation) async => allSynchronizableC[0]);
    when(cGroup.repository.load('c2')).thenAnswer((realInvocation) async => allSynchronizableC[1]);

    await useCase();

    verify(aGroup.repository.delete('a1')).called(1);
    verify(aGroup.repository.delete('a3')).called(1);
    verifyNever(aGroup.repository.delete('a2'));
    verify(bGroup.repository.delete('b2'));
  });

  test('should continue synchronization when element throws', () async {
    final allSynchronizableA = [
      FakeNotSynchronized<A>(),
      FakeSynchronizedExpired<A>(),
    ];
    final allSynchronizableB = [
      FakeSynchronized<B>(),
      FakeNotSynchronized<B>(),
    ];
    final allSynchronizableC = [
      FakeNotSynchronized<C>(),
      FakeNotSynchronized<C>(),
    ];

    final aGroup = groups[0] as SynchronizableGroup<A>;
    when(aGroup.repository.getAllIds()).thenAnswer((realInvocation) async => ['a1', 'a2']);
    when(aGroup.repository.load('a1')).thenAnswer((realInvocation) async => allSynchronizableA[0]);
    when(aGroup.repository.load('a2')).thenAnswer((realInvocation) async => allSynchronizableA[1]);

    final bGroup = groups[1] as SynchronizableGroup<B>;
    when(bGroup.repository.getAllIds()).thenAnswer((realInvocation) async => ['b1', 'b2']);
    when(bGroup.repository.load('b1')).thenAnswer((realInvocation) async => allSynchronizableB[0]);
    when(bGroup.repository.load('b2')).thenAnswer((realInvocation) async => allSynchronizableB[1]);

    final cGroup = groups[2] as SynchronizableGroup<C>;
    when(cGroup.repository.getAllIds()).thenAnswer((realInvocation) async => ['c1', 'c2']);
    when(cGroup.repository.load('c1')).thenAnswer((realInvocation) async => allSynchronizableC[0]);
    when(cGroup.repository.load('c2')).thenAnswer((realInvocation) async => allSynchronizableC[1]);

    when(aGroup.synchronizeWithRemoteUseCase!.call(allSynchronizableA[0])).thenThrow(Exception('error'));

    await useCase();

    verify(aGroup.synchronizeWithRemoteUseCase!.call(allSynchronizableA[0])).called(1);
    verify(cGroup.synchronizeWithRemoteUseCase!.call(allSynchronizableC[0])).called(1);
    verify(cGroup.synchronizeWithRemoteUseCase!.call(allSynchronizableC[1])).called(1);
  });
}

class FakeNotSynchronized<T> extends Fake implements NotSynchronized<T> {
  @override
  bool get isExpired => false;
}

class FakeSynchronizedExpired<T> extends Fake implements Synchronized<T> {
  @override
  bool get isExpired => true;
}

class FakeSynchronized<T> extends Fake implements Synchronized<T> {
  @override
  bool get isExpired => false;
}

class A {}

class B {}

class C {}
