require 'benchmark'

namespace :export do
  MOVIE_NODES = 'movie_nodes'
  PERSON_NODES = 'person_nodes'
  MOVIE_PERSON_RELATIONSHIPS = 'movie_person_relationships'
  GENRE_NODES = 'genre_nodes'
  MOVIE_GENRE_RELATIONSHIPS = 'movie_genre_relationships'

  DROP_TEMP_TABLES = <<-SQL
    DROP TABLE IF EXISTS #{MOVIE_NODES};
    DROP TABLE IF EXISTS #{PERSON_NODES};
    DROP TABLE IF EXISTS #{MOVIE_PERSON_RELATIONSHIPS};
    DROP TABLE IF EXISTS #{GENRE_NODES};
    DROP TABLE IF EXISTS #{MOVIE_GENRE_RELATIONSHIPS};
  SQL
  CREATE_MOVIE_NODES_TABLE = <<-SQL
    SELECT row_number() OVER (ORDER BY title.id) as node_id, title.id as title_id, title AS movie_title, 
    production_year, movie_info_idx.info as rating
    INTO #{MOVIE_NODES} 
    FROM title 
    INNER JOIN movie_info_idx ON movie_info_idx.movie_id = title.id 
    WHERE kind_id = 1
    AND movie_info_idx.info_type_id = 101
    ORDER BY title.id
  SQL
  #kind_id 1 is the a feature of type movie.
  CREATE_PERSON_NODES_TABLE = <<-SQL
    SELECT (SELECT count(*) from movie_nodes)+row_number() OVER (ORDER BY person_info.id) as node_id, person_info.id as person_info_id, person_info.person_id, person_info.info as name 
    INTO #{PERSON_NODES} 
    FROM person_info 
    INNER JOIN info_type ON info_type.id = person_info.info_type_id 
    WHERE info_type.id = 26
    ORDER BY person_info.id
  SQL
  #info_type.id 26 is the birth name of a person
  CREATE_GENRE_NODES_TABLE = <<-SQL
    SELECT (SELECT count(*) FROM movie_nodes)+(SELECT count(*) FROM person_nodes)+row_number() OVER () as node_id, movie_info.info as name 
    INTO #{GENRE_NODES}
    FROM movie_info 
    INNER JOIN info_type ON movie_info.info_type_id = info_type.id 
    WHERE info_type.id = 3 
    GROUP BY movie_info.info
  SQL
  CREATE_MOVIE_PERSON_RELATIONSHIPS_TABLE = <<-SQL
    SELECT movie_nodes.node_id AS start, person_nodes.node_id AS end, role_type.role AS type 
    INTO #{MOVIE_PERSON_RELATIONSHIPS}
    FROM cast_info 
    INNER JOIN movie_nodes ON movie_nodes.title_id = cast_info.movie_id 
    INNER JOIN person_nodes ON person_nodes.person_id = cast_info.person_id 
    INNER JOIN role_type ON role_type.id = cast_info.role_id
  SQL
  CREATE_MOVIE_GENRE_RELATIONSHIPS_TABLE = <<-SQL
    SELECT movie_nodes.node_id AS start, genre_nodes.node_id AS end, 'genre' as type
    INTO #{MOVIE_GENRE_RELATIONSHIPS}
    FROM movie_info 
    INNER JOIN movie_nodes ON movie_nodes.title_id = movie_info.movie_id 
    INNER JOIN genre_nodes ON genre_nodes.name = movie_info.info 
    WHERE movie_info.info_type_id = 3
  SQL
  PERSON_NODES_TO_CSV = <<-SQL
  SQL

  desc "exports movie/person tables to nodes and relationships"
  task :neo4j_csv => [:environment] do
    #Setting up the nodes and relationships tables. Doing pretty much the same thing described 
    #in this blog post, just for the IMDBPy schema: http://maxdemarzi.com/2012/02/28/batch-importer-part-2/
    execute_script_with_log('DROP TEMP TABLES', DROP_TEMP_TABLES)
    execute_script_with_log('CREATE MOVIE NODES TABLE', CREATE_MOVIE_NODES_TABLE)
    execute_script_with_log('CREATE PERSON NODES TABLE', CREATE_PERSON_NODES_TABLE)
    execute_script_with_log('CREATE MOVIE PERSON RELATIONSHIPS TABLE', CREATE_MOVIE_PERSON_RELATIONSHIPS_TABLE)
    execute_script_with_log('CREATE GENRE NODES TABLE', CREATE_GENRE_NODES_TABLE)
    execute_script_with_log('CREATE MOVIE GENRE RELATIONSHIPS TABLE', CREATE_MOVIE_GENRE_RELATIONSHIPS_TABLE)

    export_to_csv(['node_id', 'title_id', 'movie_title', 'production_year', 'rating'], MOVIE_NODES)
    export_to_csv(['node_id','person_id','name'], PERSON_NODES)
    export_to_csv(['start',"#{MOVIE_PERSON_RELATIONSHIPS}.end",'type'], MOVIE_PERSON_RELATIONSHIPS)
    export_to_csv(['node_id','name'], GENRE_NODES)
    export_to_csv(['start',"#{MOVIE_GENRE_RELATIONSHIPS}.end",'type'], MOVIE_GENRE_RELATIONSHIPS)
  end

  def execute_script_with_log(name, script)
    puts "Executing #{name}..."
    benchmark = Benchmark.realtime do
      ActiveRecord::Base.connection.execute(script)
    end
    puts "Finished executing #{name} in #{benchmark} seconds"
  end

  def export_to_csv(columns, table_name)
    save_path = "#{Rails.root}/#{table_name}.csv"
    script = <<-SQL
      copy (SELECT #{columns.join(', ')} FROM #{table_name}) TO '#{save_path}' csv header delimiter E'\t'
    SQL
    execute_script_with_log("COPY TABLE #{table_name} to #{save_path}", script)
  end
end
