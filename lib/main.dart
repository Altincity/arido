import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/about_screen.dart';
import 'screens/contact_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(FooterApp());

class FooterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arido Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      locale: Locale('ar'), // زبان پیش‌فرض عربی است
      supportedLocales: [
        Locale('en'), // انگلیسی
        Locale('ar'), // عربی
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate, 
        GlobalWidgetsLocalizations.delegate, 
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) {
          return supportedLocales.first; // اگر هیچ زبان خاصی پیدا نشد، از اولین زبان استفاده می‌کند
        }
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale; // زبان را با توجه به زبان‌های پشتیبانی‌شده تطبیق می‌دهد
          }
        }
        return supportedLocales.first; // اگر زبان تطبیق نیافت، زبان پیش‌فرض انتخاب می‌شود
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // لیست ویجت‌هایی که در هر بخش نمایش داده می‌شوند
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CategoriesScreen(),
    AboutScreen(),
    ContactScreen(),
  ];

  // هنگامی که آیتمی از BottomNavigationBar انتخاب می‌شود
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // جهت متن را راست به چپ تنظیم می‌کند
      child: Scaffold(
        appBar: AppBar(
          title: Text('Arido Application'),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الرئيسية', // عنوان بخش اول
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'التصنيفات', // عنوان بخش دوم
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'معلومات عنا', // عنوان بخش سوم
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_mail),
              label: 'اتصل بنا', // عنوان بخش چهارم
            ),
          ],
          currentIndex: _selectedIndex, // شاخص بخش فعال
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
