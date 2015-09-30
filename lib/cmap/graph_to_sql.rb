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

  private

  def ordered_edges
    graph.edges.sort_by {|e| graph.shortest_path(table_name, e.destination_vertex).length}
  end

  def unique_edges
    ordered_edges.uniq {|e| [e.value, e.destination_vertex]}
  end

  def edge_to_query(edge)
    column = edge.destination_vertex
    query = edge.value
    "alter table #{table_name} add column #{column} int2; update #{table_name} set #{column} = 1 where (#{query});"
  end

  def queries
    r = []
    unique_edges.each do |edge|
      r.push(edge_to_query(edge))
    end
    r
  end

  def connection
    @connection ||= PGconn.connect(db_config)
  end

end; end

