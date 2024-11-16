import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import 'all_universities_screen.dart';
import 'university_detail_screen.dart';
import 'all_courses_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _dynamicLabels = [];
  Map<String, List<String>> _dynamicOptions = {};
  List<String> _sliderImages = [];
  List<Map<String, dynamic>> _universities = [];
  List<Map<String, dynamic>> _courses = [];
  List<Map<String, dynamic>> _filteredCourses = [];
  bool _isLoadingSliders = true;
  bool _isLoadingUniversities = true;
  bool _isLoadingCourses = true;

  List<String> _selections = List.filled(6, '');

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchSliders();
    _fetchUniversities();
    _fetchCourses();
    _fetchSearchInformation();
  }

  Future<void> _fetchSliders() async {
    try {
      final sliders = await apiService.fetchSliders();
      setState(() {
        _sliderImages = sliders.cast<String>();
        _isLoadingSliders = false;
      });
    } catch (e) {
    }
  }

  Future<void> _fetchUniversities() async {
    try {
      final universities = await apiService.fetchUniversities();
      setState(() {
        _universities = universities;
        _isLoadingUniversities = false;
      });
    } catch (e) {
    }
  }

  Future<void> _fetchCourses() async {
    try {
      final courses = await apiService.fetchCourses();
      setState(() {
        _courses = courses;
        _isLoadingCourses = false;
        _filteredCourses = courses;
      });
    } catch (e) {
    }
  }

  Future<void> _fetchSearchInformation() async {
    try {
      final searchOptions = await apiService.fetchSearchOptions();
      setState(() {
        _dynamicLabels = searchOptions.keys.toList();
        _dynamicOptions = searchOptions;
      });
    } catch (e) {
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _performSearch() {
    setState(() {
      _filteredCourses = _courses.where((course) {
        for (int i = 0; i < _selections.length; i++) {
          if (_selections[i].isNotEmpty && !course.values.contains(_selections[i])) {
            return false;
          }
        }
        return true;
      }).toList();

      _navigateTo(context, AllCoursesScreen(courses: _filteredCourses));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> labels = ['انتخاب اول', 'انتخاب دوم', 'انتخاب سوم', 'انتخاب چهارم', 'انتخاب پنجم', 'انتخاب ششم'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 4.0,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              'شركة اريدو',
              style: TextStyle(
                fontFamily: 'Arial',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: _isLoadingSliders || _isLoadingUniversities || _isLoadingCourses
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _buildSearchBox(),
                  SizedBox(height: 20),
                  _buildCarouselSlider(_sliderImages, height: 250.0),
                  SizedBox(height: 20),
                  _buildLinkBox(
                    title: 'عرض نماذج شركة أريدو',
                    url: 'https://aridoiraq.com/',
                    description:
                        'يمكنك استخدام هذا القسم لعرض نماذج اریدو وإرسالها إلى الموقع',
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الجامعات',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      _buildNavigationButton(
                        text: 'عرض الكل',
                        onPressed: () => _navigateTo(context,
                            AllUniversitiesScreen(universities: _universities)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildUniversitiesSlider(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الدورات',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      _buildNavigationButton(
                        text: 'عرض الكل',
                        onPressed: () => _navigateTo(context,
                            AllCoursesScreen(courses: _courses)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildCoursesCarouselSlider(_filteredCourses, height: 250.0),
                ],
              ),
            ),
    );
  }

  Widget _buildUniversitiesSlider() {
    List<Widget> items = [];

    for (int i = 0; i < _universities.length; i += 1) {
      items.add(_buildUniversityCard(i));
    }

    return carousel_slider.CarouselSlider(
      options: carousel_slider.CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeStrategy: carousel_slider.CenterPageEnlargeStrategy.height,
      ),
      items: items,
    );
  }

  Widget _buildUniversityCard(int index) {
    final university = _universities[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                UniversityDetailScreen(university: university),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 4),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            university['universitie_image'] as String,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSlider(List<String> imageUrls,
      {required double height, Function(int index)? onTap}) {
    return carousel_slider.CarouselSlider(
      options: carousel_slider.CarouselOptions(
        height: height,
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeStrategy: carousel_slider.CenterPageEnlargeStrategy.height,
      ),
      items: imageUrls.map((imageUrl) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: onTap != null
                  ? () => onTap(imageUrls.indexOf(imageUrl))
                  : null,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildCoursesCarouselSlider(List<Map<String, dynamic>> courses,
      {required double height}) {
    return carousel_slider.CarouselSlider(
      options: carousel_slider.CarouselOptions(
        height: height,
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeStrategy: carousel_slider.CenterPageEnlargeStrategy.height,
      ),
      items: courses.map((course) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UniversityDetailScreen(
                      university: course, // فرض می‌کنیم یک صفحه برای جزئیات دوره است
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(course['course_image'],
                          fit: BoxFit.cover, width: double.infinity),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.black.withOpacity(0.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(course['course_expertise'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            SizedBox(height: 5),
                            Text(
                              course['course_content'].length > 50
                                  ? course['course_content'].substring(0, 50) +
                                      '...'
                                  : course['course_content'],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildNavigationButton(
      {required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      child: Text(text, style: TextStyle(fontSize: 16)),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget _buildLinkBox(
      {required String title,
      required String url,
      required String description}) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(description,
                style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _launchURL(url),
                child: Text('افتح الرابط',
                    style: TextStyle(
                        fontSize: 16, color: Theme.of(context).primaryColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return _dynamicLabels.isEmpty
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ابحث',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ...List.generate((_dynamicLabels.length / 2).ceil(),
                          (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: Row(
                            children: [
                              if (index * 2 < _dynamicLabels.length)
                                _buildDropdownForIndex(index * 2),
                              if (index * 2 + 1 < _dynamicLabels.length)
                                SizedBox(width: 10),
                              if (index * 2 + 1 < _dynamicLabels.length)
                                _buildDropdownForIndex(index * 2 + 1),
                            ],
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _performSearch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            'ابحث',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildDropdownForIndex(int index) {
    String label = _dynamicLabels[index];
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selections[index].isNotEmpty ? _selections[index] : null,
                hint: Text('يختار'),
                items: _dynamicOptions[label]!.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selections[index] = newValue;
                    });
                  }
                },
                isExpanded: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
