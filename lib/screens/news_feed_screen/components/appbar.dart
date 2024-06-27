import 'package:flutter/material.dart';
import 'package:news_app/models/country_model.dart';
import 'package:news_app/screens/news_feed_screen/components/countries_alert_dialog.dart';
import 'package:news_app/services/country_service.dart';

class AppbarContent extends StatefulWidget {
  final Function(dynamic) onChosenItem;

  AppbarContent({Key? key, required this.onChosenItem}) : super(key: key);

  @override
  _AppbarContentState createState() => _AppbarContentState();
}

class _AppbarContentState extends State<AppbarContent> {
  CountryModel currentCountry = CountryService().getFirstCountry();
  List<CountryModel> allCountries = CountryService().getAllCountries();

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomerAlertDialogWidget(
                  title: 'Escolha um País',
                  items: allCountries,
                  onTapFunction: (int index) {
                    setState(() {
                      currentCountry = allCountries[index];
                      widget.onChosenItem(allCountries[index]);
                      Navigator.pop(context);
                    });
                  },
                );
              },
            );
          },
          child: Text(currentCountry.countryName),
        ),
      ),
    );
  }
}
