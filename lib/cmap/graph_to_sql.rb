module Cmap; class GraphToSql

  attr_reader :table_name, :graph, :gsubs

  def initialize(table_name, graph, gsubs = [])
    @table_name = table_name
    @graph = graph
    @gsubs = gsubs
  end

  def queries
    edges.inject([]) do |memo, edge|
      memo.push(edge_to_query(edge))
      memo
    end
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

  def edges
    graph.ordered_edges.uniq {|e| [e.destination_vertex, e.value]}
  end

end; end

