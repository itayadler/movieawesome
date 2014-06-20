## What is this?

A playground for movie recommendation engines.

## Requirements

* Ruby 1.9.3-p429
* PostgreSQL 9.3+
* Maven
  - Install on Mac OSX: `brew install maven`

## Building the graph

### TL;DR

Here's how you build the graph with pre-made CSV files of the graph, ready for 
`batch-import` (No need for PostgreSQL):

1. `bundle install`
2. `git submodule update --init`
3. `rake neo4j:install`
4. `./scripts/import_csv.sh`

### From scratch

1. Download from IMDB their database aka [Plain Text Data 
Files](http://www.imdb.com/interfaces)
  - [Here's a gist](https://gist.github.com/itayadler/7032229) I wrote that handles the download from IMDB
2. Run [IMDBPy](http://imdbpy.sourceforge.net/) on the "Plain Text Data Files" to create a PostgreSQL database
  - Example: `imdbpy2sql.py -d /Users/itay/Development/movieawesome/imdbdb -u 'postgres://awesome:1234@localhost/imdb'`
3. Run `rake export:neo4j_csv` to convert the movie data from PostgreSQL to Neo4j
`export.rake` defines the graph and exports it to CSV files, so at the moment this is where
the graph can be customised
4. Import the CSV files to neo4j using [batch-import](https://github.com/jexp/batch-import)
  - Example: 
  `mvn test-compile exec:java -Dexec.mainClass="org.neo4j.batchimport.Importer" 
  -Dexec.args="sample/batch.properties graph.db 
  movie_nodes.csv,person_nodes.csv,genre_nodes.csv 
  movie_person_relationships.csv,movie_genre_relationships.csv" -X`
