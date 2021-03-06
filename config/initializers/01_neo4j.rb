require 'yaml'

neo4j_config = YAML::load_file("#{Rails.root}/config/neo4j.yml")
ENV["NEO4J_URL"] ||= neo4j_config[Rails.env]["server"]

uri = URI.parse(ENV["NEO4J_URL"])

$neo = Neography::Rest.new(uri.to_s)

Neography.configure do |c|
  c.server = uri.host
  c.port = uri.port

  if uri.user && uri.password
    c.authentication = 'basic'
    c.username = uri.user
    c.password = uri.password
  end
end
