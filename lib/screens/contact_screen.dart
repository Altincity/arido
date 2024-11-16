import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>>? contactData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContactInfo();
  }

  Future<void> _loadContactInfo() async {
    try {
      final response = await apiService.fetchContactInfo();
      setState(() {
        contactData = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اتصل بنا'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : contactData != null
              ? ListView.builder(
                  itemCount: contactData!.length,
                  itemBuilder: (context, index) {
                    final contact = contactData![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          leading: Icon(Icons.contact_phone, color: Colors.teal),
                          title: Text(
                            contact['contact_title'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[800],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              contact['contact_content'],
                              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                          trailing: contact['contact_content'] != null
                              ? IconButton(
                                  icon: Icon(Icons.phone, color: Colors.green),
                                  onPressed: () => _makePhoneCall(contact['contact_content']),
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                )
              : Center(child: Text('متاسفانه بارگذاری اطلاعات با مشکل مواجه شد')),
    );
  }
}
