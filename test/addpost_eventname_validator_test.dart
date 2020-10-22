import 'package:Runbhumi/utils/validations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Empty event name Test', () {
    var result = Validations.validateNonEmpty('');
    expect(result, 'This is Required!');
  });
  test('Invalid event name Test', () {
    var result = Validations.validateNonEmpty('@#sdgfh');
    expect(result, 'Please enter only alphabetical characters.');
  });
  test('Valid Email Test', () {
    var result = Validations.validateNonEmpty('some event name');
    expect(result, null);
  });
}
