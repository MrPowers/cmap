module Cmap; class GraphToSql

  attr_reader :table_name, :graph, :db_config

  def initialize(table_name, graph, db_config)
    @table_name = table_name
    @graph = graph
    @db_config = db_config
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
    "alter table #{table_name} add column #{column} int2; update #{table_name} set #{column} = 1 where (#{query});"
  end

  def queries
    graph.ordered_edges.inject([]) do |memo, edge|
      memo.push(edge_to_query(edge))
      memo
    end
  end

end; end

