import 'package:flutter/material.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Country State and City Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String countryValue;
  String stateValue;
  String cityValue;
  FormGroup formGroup = new FormGroup({
    'country': FormControl<String>(value: 'Pakistan', validators: [
      Validators.required,
    ]),
    'province': FormControl<String>(value: 'Sindh', validators: [
      Validators.required,
    ]),
    'city': FormControl<String>(
      value: 'Karachi',
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country State and City Picker'),
      ),
      body: ReactiveForm(
        formGroup: formGroup,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              CountryStateCityPicker(
                countryFormControl: formGroup.control('country'),
                stateFormControl: formGroup.control('province'),
                cityFormControl: formGroup.control('city'),
                onCountryChanged: (value) {
                  print(value);
                  // setState(() {
                  //   countryValue = value;
                  // });
                },
                onStateChanged: (value) {
                  print(value);
                  // setState(() {
                  //   stateValue = value;
                  // });
                },
                onCityChanged: (value) {
                  print(value);
                  // setState(() {
                  //   cityValue = value;
                  // });
                },
              ),
              SizedBox(
                height: 16,
              ),
              ReactiveFormConsumer(
                builder: (context, form, child) {
                  return RaisedButton(
                    child: Text('Submit'),
                    onPressed: form.valid
                        ? () {
                            print(form.value);
                          }
                        : () {
                            form.markAllAsTouched();
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
