## What is this?

A playground for movie recommendation engines.

## Rough draft of how to create a graph

1. Download from IMDB their database aka [Plain Text Data 
Files](http://www.imdb.com/interfaces)
  - [Here's a gist](https://gist.github.com/itayadler/7032229) I wrote that handles the download from IMDB
2. Run [IMDBPy](http://imdbpy.sourceforge.net/) on the "Plain Text Data Files" to create a PostgreSQL database
  - Example: `imdbpy2sql.py -d /Users/itay/Development/movieawesome/imdbdb -u 'postgres://awesome:1234@localhost/imdb'`
3. Run `rake export:neo4j_csv` to convert the movie data from PostgreSQL to neo4j
`export.rake` defines the graph and exports it to CSV files, so at the moment this is where
the graph can be customised
4. Import the CSV files to neo4j using [batch-import](https://github.com/jexp/batch-import)
  - Example: 
  `mvn test-compile exec:java -Dexec.mainClass="org.neo4j.batchimport.Importer" 
  -Dexec.args="sample/batch.properties graph.db 
  movie_nodes.csv,person_nodes.csv,genre_nodes.csv 
  movie_person_relationships.csv,movie_genre_relationships.csv" -X`

## Requirements

* Ruby 1.9.3-p429
* Neo4j 1.9+
* PostgreSQL 9.3+

## Prerequisites (Instructions for Mac OSX)

- Installing `batch-import`
  1. `git submodule update --init`
  2. `brew install maven`
- Installing Neo4j 1.9.4
  NOTE: The Gemfile.lock is on a `neography` version that should install 1.9.4
  0. `bundle install` #(Assuming you've done this already)
  1. `rake neo4j:install`

## TODO

- [ ] !! Streamline the process of creating a graph from scratch
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
- [ ] Use IMDB's autocomplete instead of the local fuzzy search to improve movie 
  search
 (Example)[http://lab.abhinayrathore.com/imdb_suggest]
- [ ] Add production year and imdb rating to movie title
- [ ] Add user history
- [ ] Intro popup 
-   [ ] Choose a genre (from a movie buff list)
-   [ ] Choose your destiny (movie)
