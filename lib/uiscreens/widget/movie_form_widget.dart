import 'package:flutter/material.dart';

class MoviesFormWidget extends StatelessWidget {
  final String? name;
  final String? director;
  final ValueChanged<String> onChangedName;
  final ValueChanged<String> onChangedDirector;

  const MoviesFormWidget({
    Key? key,
    this.name = '',
    this.director = '',
    required this.onChangedName,
    required this.onChangedDirector,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              buildTitle(),
              SizedBox(height: 8),
              buildDirector(),
              SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: name,
        style: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.normal,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Name',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'The name cannot be empty' : null,
        onChanged: onChangedName,
      );

  Widget buildDirector() => TextFormField(
        maxLines: 1,
        initialValue: director,
        style: TextStyle(color: Colors.white60, fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Director Name',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The director name cannot be empty'
            : null,
        onChanged: onChangedDirector,
      );
}
