module Cmap; class GraphToSql

  attr_reader :table_name, :graph, :query_gsubs

  def initialize(table_name, graph, query_gsubs = [])
    @table_name = table_name
    @graph = graph
    @query_gsubs = query_gsubs
  end

  def queries
    sorted_grouped_edges.inject([]) do |memo, (_, edges)|
      memo += (EdgesToQueries.new(edges, table_name, query_gsubs).queries)
      memo
    end
  end

  private

  def sorted_grouped_edges
    Hash[grouped_edges.sort]
  end

  def grouped_edges
    graph.edges.group_by {|e| graph.longest_path(table_name, e.destination_vertex).length}
  end

end; end

