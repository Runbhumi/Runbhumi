class Validations {
  /*
  This method validates that the given value in the parameter is non empty as well as does not contain special characters
  Parameter: value: String
  */
  static String validateNonEmpty(String value) {
    if (value.isEmpty) return 'This is Required!';
    final RegExp nameExp = new RegExp(r'^[A-za-zğüşöçİĞÜŞÖÇ ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  /*
  This method validates that the given value in the parameter is non empty. Can contain special characters
  Parameter: value: String
  */
  static String validateName(String value) {
    if (value.isEmpty) return 'This is Required!';
    return null;
  }

  /*
  This method validates that the given value in the parameter is in the form of an email.
  Parameter: value: String
  */
  static String validateEmail(String value) {
    if (value.isEmpty) return 'Please enter an Email Address.';
    final RegExp nameExp = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,2"
        r"53}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-z"
        r"A-Z0-9])?)*$");
    if (!nameExp.hasMatch(value)) return 'Invalid email address';
    return null;
  }

  /*
  This method validates that the given value in the parameter is a strong password.
  Conditions: value should be non empty and length should be 8 or more
  Parameter: value: String
  */
  static String validatePassword(String value) {
    if (value.isEmpty || value.length < 8)
      return 'Please enter a valid password.';
    return null;
  }
}
