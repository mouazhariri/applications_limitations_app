import 'package:flutter_test/flutter_test.dart';

import 'package:applications_limitations/src/core/utils/either.dart';

void main() {
  test('Either folds left and right values', () {
    const left = Left<String, int>('error');
    const right = Right<String, int>(7);

    expect(left.fold((value) => value, (value) => '$value'), 'error');
    expect(right.fold((value) => 0, (value) => value + 1), 8);
  });
}
