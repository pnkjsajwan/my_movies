import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_movies/Database/MovieDB.dart';
import 'package:my_movies/Model/Movie.dart';
import 'package:my_movies/uiscreens/widget/movie_form_widget.dart';
import 'package:my_movies/uiscreens/widget/utilty.dart';

class AddEditMoviePage extends StatefulWidget {
  final Movie? movie;

  const AddEditMoviePage({
    Key? key,
    this.movie,
  }) : super(key: key);

  @override
  _AddEditMoviePageState createState() => _AddEditMoviePageState();
}

class _AddEditMoviePageState extends State<AddEditMoviePage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String director;
  late String moviePoster;

  @override
  void initState() {
    super.initState();
    name = widget.movie?.name ?? '';
    director = widget.movie?.director ?? '';
    moviePoster = widget.movie?.moviePoster ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Column(
          children: [
            Form(
              key: _formKey,
              child: MoviesFormWidget(
                name: name,
                director: director,
                onChangedName: (title) => setState(() => this.name = title),
                onChangedDirector: (description) =>
                    setState(() => this.director = description),
              ),
            ),
            moviePoster != '' ? viewImage() : uploadImage(),
          ],
        ),
      );

  Widget viewImage() => Container(
      height: 200,
      width: 150,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Utility.imageFromBase64String(moviePoster)));

  pickImageFromGallery() async {
    var _image2 = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
    );
    if (_image2 != null) {
      var imageBytes = Utility.base64String(await _image2.readAsBytes());
      setState(() {
        moviePoster = imageBytes;
      });
    }
  }

  Widget uploadImage() => TextButton(
      style: TextButton.styleFrom(
          primary: Colors.black, backgroundColor: Colors.white70),
      onPressed: () {
        pickImageFromGallery();
      },
      child: Text("Pick Poster"));

  Widget buildButton() {
    final isFormValid =
        name.isNotEmpty && director.isNotEmpty && moviePoster.isNotEmpty;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.white70,
        ),
        onPressed: addOrUpdateMovies,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateMovies() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid && moviePoster != '') {
      final isUpdating = widget.movie != null;
      if (isUpdating) {
        await updateMovies();
      } else {
        await addMovie();
      }

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please upload movie poster'),
      ));
    }
  }

  Future updateMovies() async {
    final movieData = widget.movie!
        .copy(name: name, director: director, moviePoster: moviePoster);
    await MovieDB.instance.update(movieData);
  }

  Future addMovie() async {
    final movieData = Movie(
      name: name,
      director: director,
      moviePoster: moviePoster,
    );

    await MovieDB.instance.create(movieData);
  }
}
