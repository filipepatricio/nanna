import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/save_synchronizable_item_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../generated_mocks.mocks.dart';

void main() {
  late SaveSynchronizableItemUseCase useCase;

  setUp(() {
    useCase = SaveSynchronizableItemUseCase();
  });

  group('when there is not item saved', () {
    test('save the item without any changes', () async {
      final repository = MockSynchronizableRepository();
      final item = Synchronizable.createNotSynchronized('id', Duration.zero);

      when(repository.load(item.dataId)).thenAnswer((_) async => null);
      when(repository.save(item)).thenAnswer((_) async {});

      await useCase(repository, item);

      verify(repository.load(item.dataId));
      verify(repository.save(item));
    });
  });

  group('when there is an item saved', () {
    test('save the item with the longest expiration date', () async {
      final repository = MockSynchronizableRepository<String>();
      final item = Synchronizable.createNotSynchronized<String>('id', const Duration(days: 2));
      final existingItem = Synchronizable.createNotSynchronized<String>('id', const Duration(days: 3));

      when(repository.load(item.dataId)).thenAnswer((_) async => existingItem);
      when(repository.save(any)).thenAnswer((_) async {});

      await useCase(repository, item);

      verify(repository.load(item.dataId));
      verify(
        repository.save(
          argThat(
            isA<Synchronizable<String>>().having(
              (s) => s.expirationDate,
              'expirationDate',
              existingItem.expirationDate,
            ),
          ),
        ),
      );

      final item2 = Synchronizable.createNotSynchronized<String>('id', const Duration(days: 4));

      when(repository.load(item2.dataId)).thenAnswer((_) async => existingItem);

      await useCase(repository, item2);

      verify(repository.load(item2.dataId));
      verify(
        repository.save(
          argThat(
            isA<Synchronizable<String>>().having(
              (s) => s.expirationDate,
              'expirationDate',
              item2.expirationDate,
            ),
          ),
        ),
      );
    });

    test('save the item with the latest data', () async {
      final repository = MockSynchronizableRepository<String>();
      final item = Synchronizable.createSynchronized<String>(
        'data',
        'id',
        const Duration(days: 2),
      );
      final existingItem = Synchronizable.createNotSynchronized<String>('id', Duration.zero);

      when(repository.load(item.dataId)).thenAnswer((_) async => existingItem);
      when(repository.save(any)).thenAnswer((_) async {});

      await useCase(repository, item);

      verify(repository.load(item.dataId));
      verify(
        repository.save(
          argThat(
            isA<Synchronizable<String>>().having(
              (s) => s.data,
              'data',
              item.data,
            ),
          ),
        ),
      );

      final item2 = Synchronizable.createNotSynchronized<String>('id', Duration.zero);
      final existingItem2 = Synchronizable.createSynchronized<String>(
        'data',
        'id',
        const Duration(days: 2),
      );

      when(repository.load(item2.dataId)).thenAnswer((_) async => existingItem2);
      when(repository.save(any)).thenAnswer((_) async {});

      await useCase(repository, item2);

      verify(repository.load(item2.dataId));
      verify(
        repository.save(
          argThat(
            isA<Synchronizable<String>>().having(
              (s) => s.data,
              'data',
              existingItem2.data,
            ),
          ),
        ),
      );
    });
  });
}
