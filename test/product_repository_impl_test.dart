import 'package:ecommerce/features/products/data/data_sources/local/local_data_source.dart';
import 'package:ecommerce/features/products/data/model/product_Model.dart';
import 'package:ecommerce/features/products/data/repository/product_repository_impl.dart';
import 'package:ecommerce/features/products/domain/entities/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDataSource extends Mock implements LocalDataSource {}

void main() {
  late ProductRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    repository = ProductRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  final tProductModel = ProductModel(
    productId: '1',
    productName: 'Test Product',
    productDescription: 'Description',
    productPrice: 99.99,
    imageUrl: 'image.png',
    productCategory: 'Electronics',
    createdAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
  );
  final tProductEntity = tProductModel.toEntity();

  group('getAllProducts', () {
    test(
      'should return a list of productEntity when local data source handles successfully',
      () async {
        when(() => mockLocalDataSource.getAllProducts())
            .thenAnswer((_) async => [tProductModel]);

        final result = await repository.getAllProducts();

        expect(result, isA<List<ProductEntity>>());
        expect(result.first.productId, equals(tProductEntity.productId));

        verify(() => mockLocalDataSource.getAllProducts()).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );
  });

  group('createProduct', () {
    test(
      'should forward the converted productModel to the local data Source',
      () async {
        registerFallbackValue(tProductModel);

        when(() => mockLocalDataSource.createProduct(any()))
            .thenAnswer((_) async => Future<void>.value());

        await repository.createProduct(tProductEntity);

        verify(() => mockLocalDataSource.createProduct(any())).called(1);
      },
    );
  });
}
