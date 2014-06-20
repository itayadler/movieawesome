#!/bin/bash
set -e
cd batch-import
DB=../neo4j/data/graph.db 
NODES=../export_graph_csv/movie_nodes.csv,../export_graph_csv/person_nodes.csv,../export_graph_csv/genre_nodes.csv 
RELS=../export_graph_csv/movie_person_relationships.csv,../export_graph_csv/movie_genre_relationships.csv
mvn compile exec:java -Dexec.mainClass="org.neo4j.batchimport.Importer" \
   -Dexec.args="batch.properties $DB $NODES $RELS $@" | grep -iv '\[\(INFO\|debug\)\]'
cd ..
