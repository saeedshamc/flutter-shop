class Validators {
  // Email Validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'ایمیل الزامی است';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'ایمیل نامعتبر است';
    }
    
    return null;
  }
  
  // Password Validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'رمز عبور الزامی است';
    }
    
    if (value.length < 6) {
      return 'رمز عبور باید حداقل ۶ کاراکتر باشد';
    }
    
    return null;
  }
  
  // Confirm Password Validation
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'تایید رمز عبور الزامی است';
    }
    
    if (value != password) {
      return 'رمزهای عبور یکسان نیستند';
    }
    
    return null;
  }
  
  // Required Field Validation
  static String? required(String? value, [String fieldName = 'این فیلد']) {
    if (value == null || value.isEmpty) {
      return '$fieldName الزامی است';
    }
    
    return null;
  }
  
  // Minimum Length Validation
  static String? minLength(String? value, int length, [String fieldName = 'این فیلد']) {
    if (value == null || value.isEmpty) {
      return '$fieldName الزامی است';
    }
    
    if (value.length < length) {
      return '$fieldName باید حداقل $length کاراکتر باشد';
    }
    
    return null;
  }
  
  // Maximum Length Validation
  static String? maxLength(String? value, int length, [String fieldName = 'این فیلد']) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    if (value.length > length) {
      return '$fieldName باید حداکثر $length کاراکتر باشد';
    }
    
    return null;
  }
  
  // Number Validation
  static String? number(String? value, [String fieldName = 'این فیلد']) {
    if (value == null || value.isEmpty) {
      return '$fieldName الزامی است';
    }
    
    if (double.tryParse(value) == null) {
      return '$fieldName باید عدد باشد';
    }
    
    return null;
  }
  
  // Positive Number Validation
  static String? positiveNumber(String? value, [String fieldName = 'این فیلد']) {
    if (value == null || value.isEmpty) {
      return '$fieldName الزامی است';
    }
    
    final number = double.tryParse(value);
    if (number == null) {
      return '$fieldName باید عدد باشد';
    }
    
    if (number <= 0) {
      return '$fieldName باید بزرگتر از صفر باشد';
    }
    
    return null;
  }
  
  // Phone Number Validation (Iranian)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'شماره تلفن الزامی است';
    }
    
    final phoneRegex = RegExp(r'^09[0-9]{9}$');
    
    if (!phoneRegex.hasMatch(value)) {
      return 'شماره تلفن نامعتبر است';
    }
    
    return null;
  }
}

