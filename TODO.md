## TODO

- [ ] !! Streamline the process of creating a graph from scratch
  - [ ] Setup docker
  - [x] Write a script that wraps the usage of `batch-import`
- [x] Ruby script that creates CSV files for the Movie/Person nodes and their 
  relationships
- [ ] A UI for offering movie recommendations based on a Movie using EmberJS?  
  (Consider changing it)
- [ ] Improve the neo4j import script to add indexes to nodes and edges
- [ ] Add votes count field to movie_node in order to improve recommendations 
  ordering
- [ ] Issue: Filter movies that haven't been released yet
- [ ] Issue: The recommendations should have a thumbnail. IMDBPy doesn't include 
  the imdbID of a movie, so
an API that can find a thumbnail based on a movie name and production year is 
needed..
- [x] Use IMDB's autocomplete instead of the local fuzzy search to improve movie 
  - [ ] Refactor backend to stop using MovieNode
  search
 (Example)[http://lab.abhinayrathore.com/imdb_suggest]
- [ ] Add production year and imdb rating to movie title
- [ ] Add user history
- [ ] Intro popup 
-   [ ] Choose a genre (from a movie buff list)
-   [ ] Choose your destiny (movie)
- Write a CYPHER version of the recommendations query

