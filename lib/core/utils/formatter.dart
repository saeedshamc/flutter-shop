import 'package:intl/intl.dart';

class Formatter {
  // Price Formatter (with Toman symbol)
  static String price(num price) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(price)} تومان';
  }
  
  // Number Formatter
  static String number(num number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }
  
  // Date Formatter
  static String date(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }
  
  // Date Time Formatter
  static String dateTime(DateTime dateTime) {
    return DateFormat('yyyy/MM/dd HH:mm').format(dateTime);
  }
  
  // Time Formatter
  static String time(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
  
  // Relative Time (e.g., "2 hours ago")
  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years سال پیش';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ماه پیش';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} روز پیش';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعت پیش';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقیقه پیش';
    } else {
      return 'لحظاتی پیش';
    }
  }
  
  // Discount Percentage
  static String discountPercentage(num discount) {
    return '${discount.toStringAsFixed(0)}%';
  }
  
  // File Size Formatter
  static String fileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }
  
  // Compact Number (e.g., 1.5K, 2.3M)
  static String compactNumber(num number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else if (number < 1000000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    }
  }
  
  // Calculate Final Price after Discount
  static num finalPrice(num price, num discount) {
    return price - (price * discount / 100);
  }
  
  // Format Final Price with Discount
  static String finalPriceFormatted(num price, num discount) {
    final final_price = finalPrice(price, discount);
    return Formatter.price(final_price);
  }
}

