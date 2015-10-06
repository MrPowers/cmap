module Cmap; class GraphToSql

  attr_reader :table_name, :graph, :query_gsubs, :column_gsubs

  def initialize(table_name, graph, query_gsubs = [], column_gsubs = [])
    @table_name = table_name
    @graph = graph
    @query_gsubs = query_gsubs
    @column_gsubs = column_gsubs
  end

  def queries
    edges.inject([]) do |memo, edge|
      memo.push(edge_to_query(edge))
      memo
    end
  end

  private

  def edge_to_query(edge)
    c = column(edge)
    q = query(edge)
    "alter table #{table_name} add column #{c} int2; update #{table_name} set #{c} = 1 where (#{q});"
  end

  def column(edge)
    c = edge.destination_vertex
    column_gsubs.each do |gsub|
      c = c.gsub(*gsub)
    end
    c
  end

  def query(edge)
    q = edge.value
    query_gsubs.each do |gsub|
      q = q.gsub(*gsub)
    end
    q
  end

  def edges
    graph.ordered_edges.uniq {|e| [e.destination_vertex, e.value]}
  end

end; end

