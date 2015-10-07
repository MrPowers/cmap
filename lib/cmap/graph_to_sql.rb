module Cmap; class GraphToSql

  attr_reader :table_name, :graph

  def initialize(table_name, graph)
    @table_name = table_name
    @graph = graph
  end

  def queries
    grouped_edges.inject([]) do |memo, (_, edges)|
      memo += (edges_to_queries(edges))
      memo
    end
  end

  private

  def grouped_edges
    graph.edges.group_by {|e| graph.longest_path(table_name, e.destination_vertex).length}
  end

  def edges_to_queries(edges)
    unique_edges = edges.uniq {|e| [e.destination_vertex, e.value]}
    add_columns = unique_edges.map {|e| "add column #{e.destination_vertex} int2"}.join(", ")
    updates = unique_edges.map {|e| "#{e.destination_vertex}=(#{e.value})::int"}.join(", ")
    [
      "alter table #{table_name} #{add_columns};",
      "update #{table_name} set #{updates};"
    ]
  end

end; end

