module Cmap; class GraphToSql

  attr_reader :table_name, :graph, :db_config, :gsubs

  def initialize(table_name, graph, db_config, gsubs = [])
    @table_name = table_name
    @graph = graph
    @db_config = db_config
    @gsubs = gsubs
  end

  def run_queries
    queries.each do |q|
      connection.exec(q)
    end
  end

  def connection
    @connection ||= PGconn.connect(db_config)
  end

  private

  def edge_to_query(edge)
    column = edge.destination_vertex
    query = edge.value
    q = "alter table #{table_name} add column #{column} int2; update #{table_name} set #{column} = 1 where (#{query});"
    gsubs.each do |gsub|
      q = q.gsub(*gsub)
    end
    q
  end

  def queries
    graph.ordered_edges.inject([]) do |memo, edge|
      memo.push(edge_to_query(edge))
      memo
    end
  end

end; end

