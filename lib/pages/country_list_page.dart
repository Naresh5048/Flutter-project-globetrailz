import 'package:flutter/material.dart';
import '../widgets/country_card.dart';
import 'country_detail_page.dart';

class CountryListPage extends StatelessWidget {
  final String? query;
  CountryListPage({super.key, this.query});

  // TO CHANGE COUNTRY IMAGES:
  // 1. Put your new images in the 'assets/' folder
  // 2. Update the 'asset' field below with your new image path
  // Example: 'asset':'assets/india_new.jpg'
  
  final List<Map<String, dynamic>> countries = [
    {'name':'India','asset':'assets/india.jpg','spots': [
      {'name':'Taj Mahal','place':'Agra','image':'assets/tajmahal.jpg','wiki':'https://en.wikipedia.org/wiki/Taj_Mahal','lat':27.1751,'lng':78.0421},
      {'name':'Gateway of India','place':'Mumbai','image':'assets/gatewayofindia.jpg','wiki':'https://en.wikipedia.org/wiki/Gateway_of_India','lat':18.9219,'lng':72.8347},
      {'name':'Red Fort','place':'Delhi','image':'assets/redfort.jpg','wiki':'https://en.wikipedia.org/wiki/Red_Fort','lat':28.6562,'lng':77.2410},
    ]},
    {'name':'Bhutan','asset':'assets/bhutan.jpg','spots':[{'name':'Paro Taktsang','place':'Paro','image':'assets/paro.jpg','wiki':'https://en.wikipedia.org/wiki/Paro_Taktsang','lat':27.4925,'lng':89.3240}]},
    {'name':'Nepal','asset':'assets/nepal.jpg','spots':[{'name':'Kathmandu Durbar Square','place':'Kathmandu','image':'assets/durbarsqaure.jpg','wiki':'https://en.wikipedia.org/wiki/Kathmandu_Durbar_Square','lat':27.7036,'lng':85.3096}]},
    {'name':'London','asset':'assets/london.jpg','spots':[{'name':'Tower Bridge','place':'London','image':'assets/towerbridge.jpg','wiki':'https://en.wikipedia.org/wiki/Tower_Bridge','lat':51.5055,'lng':-0.0754}]},
    {'name':'America','asset':'assets/usa.jpg','spots':[{'name':'Statue of Liberty','place':'New York','image':'assets/statue.jpg','wiki':'https://en.wikipedia.org/wiki/Statue_of_Liberty','lat':40.6892,'lng':-74.0445}]},
    {'name':'China','asset':'assets/china.jpg','spots':[{'name':'Great Wall','place':'China','image':'assets/greatwall.jpg','wiki':'https://en.wikipedia.org/wiki/Great_Wall_of_China','lat':40.4319,'lng':116.5704}]},
    {'name':'Japan','asset':'assets/japan.jpg','spots':[{'name':'Mount Fuji','place':'Japan','image':'assets/mountfuji.jpg','wiki':'https://en.wikipedia.org/wiki/Mount_Fuji','lat':35.3606,'lng':138.7274}]},
    {'name':'Russia','asset':'assets/russia.jpg','spots':[{'name':'Red Square','place':'Moscow','image':'assets/redsquare.jpg','wiki':'https://en.wikipedia.org/wiki/Red_Square','lat':55.7539,'lng':37.6208}]},
    {'name':'Israel','asset':'assets/israel.jpg','spots':[{'name':'Western Wall','place':'Jerusalem','image':'assets/westernwall.jpg','wiki':'https://en.wikipedia.org/wiki/Western_Wall','lat':31.7767,'lng':35.2345}]},
    {'name':'Africa','asset':'assets/africa.jpg','spots':[{'name':'Serengeti','place':'Tanzania','image':'assets/serengeti.jpg','wiki':'https://en.wikipedia.org/wiki/Serengeti','lat':-2.3333,'lng':34.8333}]},
  ];

// TO CHANGE TOURIST PLACE IMAGES:
// The 'image' field above defines which image each tourist place displays
// Just put your new images in 'assets/' folder and update the 'image' field value

  @override
  Widget build(BuildContext context) {
    final q = query?.trim().toLowerCase();
    final filtered = (q==null || q.isEmpty)
        ? countries
        : countries.where((c) => c['name'].toString().toLowerCase().contains(q)).toList();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        itemCount: filtered.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // Improved responsiveness
          crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : (MediaQuery.of(context).size.width > 600 ? 3 : 2),
          childAspectRatio: 0.78, 
          crossAxisSpacing: 12, 
          mainAxisSpacing: 12
        ),
        itemBuilder: (ctx, i) {
          final c = filtered[i];
          return CountryCard(
            title: c['name'],
            imagePath: c['asset'],
            // Added explicit casting to fix potential runtime type issues 
            onExplore: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => CountryDetailPage(countryName: c['name'], spots: c['spots'] as List<Map<String, dynamic>>)));
            },
          );
        },
      ),
    );
  }
}