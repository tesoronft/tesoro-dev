class FormValidators {
  // 1. Username: alphanumeric, max 10 characters, non-empty
  static String? validateUserName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Username is required";
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return "Only alphanumeric characters allowed";
    }
    if (value.length > 10) {
      return "Max 10 characters allowed";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }

    // Simple email regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email address";
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 8) {
      return "Password must be at least 6 characters";
    }
    // Optional: Strong password check
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return "Password must contain uppercase, lowercase, and a number";
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? cPass) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value != cPass) {
      return "Password dont match";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    // Optional: Strong password check
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return "Password must contain uppercase, lowercase, and a number";
    }
    return null;
  }

  // 2. Name: alphabetic, max 15 characters, non-empty
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    if (value.length > 15) {
      return 'Name cannot exceed 15 characters';
    }
    return null; // ✅ valid case
  }

  // 3. Description: 50–100 words, non-empty
  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Description is required";
    }

    if (value.length < 200) {
      return "At least 200 words required";
    }
    if (value.length > 5000) {
      return "Maximum 5000 words allowed";
    }
    return null;
  }

  static String? validateCNIC(String? value) {
    if (value == null || value.isEmpty) {
      return "CNIC is required";
    }
    // CNIC format: 5 digits - 7 digits - 1 digit
    final cnicRegex = RegExp(r'^[0-9]{5}-[0-9]{7}-[0-9]{1}$');
    if (!cnicRegex.hasMatch(value)) {
      return "Enter CNIC in correct format (e.g. 42101-1234567-1)";
    }
    return null;
  }

  // 4. Phone number: numeric, 11 digits, non-empty
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Only numeric values allowed";
    }
    if (value.length != 11) {
      return "Phone number must be 11 digits";
    }
    return null;
  }

  // 5. Experience: numeric only, non-empty
  static String? validateExperience(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Experience is required";
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Only numeric values allowed";
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Price is required";
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Only numeric values allowed";
    }
    return null;
  }

  static String? validateTreasureTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Treasure title is required";
    }
    if (value.length > 50) {
      return "Treasure title cannot exceed 50 characters";
    }
    return null;
  }

  static String? validateTreasureDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Treasure description is required";
    }
    if (value.length > 200) {
      return "Treasure description cannot exceed 200 characters";
    }
    return null;
  }

  static String? validateTreasureLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Treasure location is required";
    }
    if (value.length > 100) {
      return "Treasure location cannot exceed 100 characters";
    }
    return null;
  }

  static String? validateTreasureAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Treasure address is required";
    }
    if (value.length > 200) {
      return "Treasure address cannot exceed 200 characters";
    }
    return null;
  }

  static String? validateTreasureCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Treasure category is required";
    }
    if (value.length > 50) {
      return "Treasure category cannot exceed 50 characters";
    }
    return null;
  }

  static String? validateTreasureCondition(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Treasure condition is required";
    }
    if (value.length > 50) {
      return "Treasure condition cannot exceed 50 characters";
    }
    return null;
  }

  static String? validateTreasureModel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Treasure model is required";
    }
    if (value.length > 50) {
      return "Treasure model cannot exceed 50 characters";
    }
    return null;
  }

  static String? validateTreasureBrand(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Treasure brand is required";
    }
    if (value.length > 50) {
      return "Treasure brand cannot exceed 50 characters";
    }
    return null;
  }
}
