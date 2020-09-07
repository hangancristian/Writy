import 'dart:async';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/data.dart';

import 'package:string_validator/string_validator.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class Category {
  int id;
  String name;

  Category(this.id, this.name);

  static List<Category> getCategories() {
    return <Category>[
      Category(1, 'Tech'),
      Category(2, 'Travel'),
      Category(3, 'Food'),
      Category(4, 'Politics'),
      Category(5, 'Others'),
    ];
  }
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final data = Data(country: "", age: null, category: "");
  List<Category> _companies = Category.getCategories();
  List<DropdownMenuItem<Category>> _dropdownMenuItems;
  Category _selectedCategory;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCategory = _dropdownMenuItems[0].value;
    data.category = _selectedCategory.name;
    super.initState();
  }

  List<DropdownMenuItem<Category>> buildDropdownMenuItems(List categories) {
    List<DropdownMenuItem<Category>> items = List();
    for (Category category in categories) {
      items.add(
        DropdownMenuItem(
          value: category,
          child: Text(category.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Category selectedCategory) {
    setState(() {
      _selectedCategory = selectedCategory;
      data.category = _selectedCategory.name;
    });
  }

  submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      Navigator.pop(context, data);
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              autovalidate: true,
              child: TextFormField(
                validator: (val) {
                  if (val.isEmpty) {
                    return "Age is required";
                  } else if (!isNumeric(val)) {
                    return "Only number allowed";
                  } else {
                    return null;
                  }
                },
                onSaved: (val) => data.age = int.parse(val),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Age",
                  labelStyle: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(50),
                child: Text(
                  "Pick a country",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: CountryListPick(
                  isShowFlag: true,
                  isShowTitle: true,
                  isShowCode: false,
                  isDownIcon: true,
                  showEnglishName: true,
                  onChanged: (CountryCode code) {
                    setState(() {
                      data.country = code.name;
                    });
                  },
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Select a category"),
              SizedBox(
                height: 20.0,
              ),
              DropdownButton(
                value: _selectedCategory,
                items: _dropdownMenuItems,
                onChanged: onChangeDropdownItem,
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
          GestureDetector(
            onTap: submit,
            child: Container(
              height: 50.0,
              width: 350.0,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(7.0),
              ),
              child: Center(
                child: Text(
                  "Submit",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
