import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 主色调
  static const Color primaryColor = Color(0xFF07C160); // 微信绿
  static const Color primaryLight = Color(0xFF52D683);
  static const Color primaryDark = Color(0xFF06AD56);
  
  // 辅助色
  static const Color accentColor = Color(0xFF17B3F1); // 蓝色
  static const Color warningColor = Color(0xFFFFB900);
  static const Color errorColor = Color(0xFFF44336);
  static const Color successColor = Color(0xFF52C41A);
  
  // 中性色
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color dividerColor = Color(0xFFE5E5E5);
  
  // 文字颜色
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  static const Color textDisabled = Color(0xFFCCCCCC);
  
  // 聊天气泡颜色
  static const Color chatBubbleSelf = Color(0xFF95EC69);
  static const Color chatBubbleOther = Colors.white;
  
  // 亮色主题
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    dividerColor: dividerColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
      surface: cardColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
      onSurface: textPrimary,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: cardColor,
      foregroundColor: textPrimary,
      iconTheme: const IconThemeData(color: textPrimary),
      titleTextStyle: GoogleFonts.notoSansSC(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: textSecondary,
      indicatorColor: primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.notoSansSC(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.notoSansSC(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: cardColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.notoSansSC(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: GoogleFonts.notoSansSC(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.notoSansSC(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor),
      ),
      hintStyle: GoogleFonts.notoSansSC(
        color: textHint,
        fontSize: 14,
      ),
      labelStyle: GoogleFonts.notoSansSC(
        color: textSecondary,
        fontSize: 14,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.notoSansSC(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displayMedium: GoogleFonts.notoSansSC(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displaySmall: GoogleFonts.notoSansSC(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.notoSansSC(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleLarge: GoogleFonts.notoSansSC(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: GoogleFonts.notoSansSC(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyLarge: GoogleFonts.notoSansSC(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      bodyMedium: GoogleFonts.notoSansSC(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      bodySmall: GoogleFonts.notoSansSC(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondary,
      ),
    ),
  );
  
  // 暗色主题
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    cardColor: const Color(0xFF2C2C2C),
    dividerColor: const Color(0xFF404040),
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
      surface: Color(0xFF2C2C2C),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
      onSurface: Color(0xFFE5E5E5),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: const Color(0xFF2C2C2C),
      foregroundColor: const Color(0xFFE5E5E5),
      iconTheme: const IconThemeData(color: Color(0xFFE5E5E5)),
      titleTextStyle: GoogleFonts.notoSansSC(
        color: const Color(0xFFE5E5E5),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: GoogleFonts.notoSansSCTextTheme(
      ThemeData.dark().textTheme.copyWith(
        bodyLarge: const TextTheme().bodyLarge?.copyWith(color: const Color(0xFFE5E5E5)),
        bodyMedium: const TextTheme().bodyMedium?.copyWith(color: const Color(0xFFE5E5E5)),
        bodySmall: const TextTheme().bodySmall?.copyWith(color: const Color(0xFF999999)),
      ),
    ),
  );
}
