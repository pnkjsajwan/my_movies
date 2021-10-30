import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_movies/Database/MovieDB.dart';
import 'package:my_movies/Model/Movie.dart';
import 'package:my_movies/uiscreens/authintication/login.dart';
import 'package:my_movies/uiscreens/edit_movie_page.dart';
import 'package:my_movies/uiscreens/widget/utilty.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  late List<Movie> movies;
  bool isLoading = false;
  late SharedPreferences logindata;
  late String username;

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username')!;
    });
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    initial();
    refreshMovies();
    super.initState();
  }

  @override
  void dispose() {
    MovieDB.instance.close();
    super.dispose();
  }

  Future refreshMovies() async {
    setState(() => isLoading = true);
    this.movies = await MovieDB.instance.readAllMovies();
    setState(() => isLoading = false);
  }

  _buildLogout() {
    return TextButton(
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userID", "");
        logindata.setBool('login', true);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (Builder) => Login()), (route) => false);
      },
      child: Text(
        "Sign Out",
        style: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        maxLines: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Movies',
            style: TextStyle(fontSize: 24),
          ),
          actions: [
            _buildLogout(),
            SizedBox(
              width: 30.0,
            )
          ],
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : movies.isEmpty
                  ? Text(
                      'No Movies',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildMovies(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditMoviePage()),
            );
            refreshMovies();
          },
        ),
      );

  Widget buildMovies() => ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(minHeight: 40.0),
            padding: EdgeInsets.all(8),
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Utility.imageFromBase64String(
                                movie.moviePoster))),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.name,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Director : ${movie.director}",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned.fill(
                  right: 40.0,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        splashRadius: 20,
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.white70,
                        ),
                        onPressed: () async {
                          if (isLoading) return;
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                AddEditMoviePage(movie: movie),
                          ));

                          refreshMovies();
                        }),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white70,
                      ),
                      splashRadius: 20,
                      onPressed: () async {
                        final id = movie.id;
                        await MovieDB.instance.delete(id!);
                        setState(() {
                          refreshMovies();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

  Widget editButton(movie) => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditMoviePage(movie: movie),
        ));

        refreshMovies();
      });

  Widget deleteButton(movie) => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await MovieDB.instance.delete(movie);
          Navigator.of(context).pop();
        },
      );
}
