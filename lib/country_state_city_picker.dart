library country_state_city_picker_nona;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:reactive_forms/reactive_forms.dart';

import 'model/select_status_model.dart' as StatusModel;
import '../widgets/custom_dropdown_widget.dart';

class CountryStateCityPicker extends StatefulWidget {
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onStateChanged;
  final ValueChanged<String> onCityChanged;
  final FormControl countryFormControl;
  final FormControl stateFormControl;
  final FormControl cityFormControl;
  final String? countryLabel;
  final String? stateLabel;
  final String? cityLabel;
  final Widget? suffixWidget;

  const CountryStateCityPicker({
    Key? key,
    required this.onCountryChanged,
    required this.onStateChanged,
    required this.onCityChanged,
    required this.countryFormControl,
    required this.stateFormControl,
    required this.cityFormControl,
    this.countryLabel,
    this.stateLabel,
    this.cityLabel,
    this.suffixWidget,
  }) : super(key: key);

  @override
  _CountryStateCityPickerState createState() => _CountryStateCityPickerState();
}

class _CountryStateCityPickerState extends State<CountryStateCityPicker> {
  late Future<List> jsonDataFuture;
  List<String> _availableCountries = [];
  List<String> _availableCities = [];
  List<String> _availableStates = [];
  var jsonResponse;

  @override
  void initState() {
    jsonDataFuture = _initData();
    super.initState();
  }

  Future<List> _initData() async {
    var res = await rootBundle.loadString(
      'packages/country_state_city_picker/lib/assets/country.json',
    );
    jsonResponse = jsonDecode(res) as List;
    return jsonResponse;
  }

  setCountries() {
    if (jsonResponse != null) {
      jsonResponse.forEach((data) {
        var model = StatusModel.StatusModel();
        model.name = data['name'];
        _availableCountries.add(model.name!);
      });
    }
  }

  setStates() {
    if (jsonResponse != null) {
      var takeState = jsonResponse
          .map((map) => StatusModel.StatusModel.fromJson(map))
          .where(
            (item) => item.name == _getControlValue(widget.countryFormControl),
          )
          .map((item) => item.state)
          .toList();
      var states = takeState as List;
      states.forEach((f) {
        var name = f.map((item) => item.name).toList();
        for (var stateName in name) {
          _availableStates.add(stateName.toString());
        }
      });
    }
  }

  setCities() {
    if (jsonResponse != null) {
      var takeState = jsonResponse
          .map((map) => StatusModel.StatusModel.fromJson(map))
          .where(
            (item) => item.name == _getControlValue(widget.countryFormControl),
          )
          .map((item) => item.state)
          .toList();
      var states = takeState as List;
      states.forEach((f) {
        var name = f.where(
          (item) => item.name == _getControlValue(widget.stateFormControl),
        );
        var cityName = name.map((item) => item.city).toList();
        cityName.forEach((ci) {
          var citiesName = ci.map((item) => item.name).toList();
          for (var cityNames in citiesName) {
            _availableCities.add(cityNames.toString());
          }
        });
      });
    }
  }

  _getControlValue(FormControl control) {
    String value = '';
    try {
      value = control.value as String;
    } catch (e) {}
    return value;
  }

  void _onSelectedCountry(String value) {
    this.widget.onCountryChanged(value);
    widget.stateFormControl.value = null;
    widget.cityFormControl.value = null;
    _availableStates = [];
    _availableCities = [];
  }

  void _onSelectedState(String value) {
    this.widget.onStateChanged(value);
    widget.cityFormControl.value = null;
    _availableCities = [];
  }

  void _onSelectedCity(String value) {
    this.widget.onCityChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FutureBuilder<List>(
            future: jsonDataFuture,
            builder: (context, snapshot) {
              setCountries();
              return ReactiveDropDownWidget(
                formControl: widget.countryFormControl,
                label: widget.countryLabel ?? 'Country/Region',
                validationMessages: {
                  ValidationMessage.required: 'This field is required'
                },
                onChanged: (value) => _onSelectedCountry(value!),
                items: _availableCountries.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    child: Text(dropDownStringItem),
                    value: dropDownStringItem,
                  );
                }).toList(),
                suffixWidget: widget.suffixWidget,
              );
            }),
        SizedBox(
          height: 16,
        ),
        FutureBuilder<List>(
            future: jsonDataFuture,
            builder: (context, snapshot) {
              return ReactiveValueListenableBuilder(
                formControl: widget.countryFormControl,
                builder: (context, control, child) {
                  setStates();
                  return ReactiveDropDownWidget(
                    formControl: widget.stateFormControl,
                    label: widget.stateLabel ?? 'State',
                    validationMessages: {
                      ValidationMessage.required: 'This field is required'
                    },
                    onChanged: (value) => _onSelectedState(value!),
                    items: _availableStates.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        child: Text(dropDownStringItem),
                        value: dropDownStringItem,
                      );
                    }).toList(),
                    suffixWidget: widget.suffixWidget,
                  );
                },
              );
            }),
        SizedBox(
          height: 16,
        ),
        FutureBuilder<List>(
            future: jsonDataFuture,
            builder: (context, snapshot) {
              return ReactiveValueListenableBuilder(
                formControl: widget.stateFormControl,
                builder: (context, control, child) {
                  setCities();
                  return ReactiveDropDownWidget(
                    formControl: widget.cityFormControl,
                    label: widget.cityLabel ?? 'City',
                    validationMessages: {
                      ValidationMessage.required: 'This field is required'
                    },
                    onChanged: (value) => _onSelectedCity(value!),
                    items: _availableCities.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        child: Text(dropDownStringItem),
                        value: dropDownStringItem,
                      );
                    }).toList(),
                    suffixWidget: widget.suffixWidget,
                  );
                },
              );
            }),
      ],
    );
  }
}
