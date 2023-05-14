import 'package:flutter/material.dart';
import 'package:label_music/models/category.dart';

class BeDropdownCategory extends StatefulWidget {
  BeDropdownCategory(
      {Key? key,
      required this.title,
      required this.items,
      required this.selectedCategory,
      required this.callback})
      : super(key: key);
  final String title;
  final List<RACategory> items;
  final Function callback;
  final RACategory selectedCategory;
  @override
  State<BeDropdownCategory> createState() => _BeDropdownCategoryState();
}

class _BeDropdownCategoryState extends State<BeDropdownCategory> {
  RACategory initialCategory = RACategory(courses: []);
  @override
  void initState() {
    // TODO: implement initState
    initialCategory = widget.selectedCategory;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
          bottomRight: Radius.circular(5.0),
          topRight: Radius.circular(5.0), // FLUTTER BUG FIX
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 0),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            focusColor: Colors.white,
            value: initialCategory.name == ""
                ? widget.items[0].name
                : initialCategory.name,
            elevation: 5,
            alignment: AlignmentDirectional.center,
            style: const TextStyle(color: Colors.white),
            items:
                widget.items.map<DropdownMenuItem<String>>((RACategory value) {
              return DropdownMenuItem<String>(
                value: value.name,
                child: Text(
                  value.name,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );
            }).toList(),
            hint: Text(
              widget.title,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  print(value);
                  for (RACategory cat in widget.items) {
                    if (cat.name == value) {
                      widget.callback(cat);
                      initialCategory =
                          RACategory(courses: []).fromCategory(cat);
                      print(initialCategory.name);
                      break;
                    }
                  }
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
