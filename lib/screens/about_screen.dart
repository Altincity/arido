import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/api_service.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? aboutData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAboutInfo();
  }

  Future<void> _loadAboutInfo() async {
    try {
      final response = await apiService.fetchAboutInfo();
      setState(() {
        aboutData = response['data'][0];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('معلومات عنا'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : aboutData != null
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        aboutData!['about_title'],
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[700],
                        ),
                      ),
                      SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          aboutData!['about_image'],
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        aboutData!['about_content'],
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
                            onPressed: () => _launchURL('https://www.facebook.com/profile.php?id=61554565905702&mibextid=ZbWKwL'),
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.telegram, color: Colors.blueAccent),
                            onPressed: () => _launchURL('https://t.me/aridoco'),
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
                            onPressed: () => _launchURL('https://chat.whatsapp.com/Js62KWMf3LE7pazQ8XhPEC'),
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.purple),
                            onPressed: () => _launchURL('https://www.instagram.com/arido_co'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Center(child: Text('متاسفانه بارگذاری اطلاعات با مشکل مواجه شد')),
    );
  }
}
