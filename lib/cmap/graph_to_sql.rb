module Cmap; class GraphToSql

  attr_reader :table_name, :schema_name, :graph, :subquery_gsubs

  def initialize(table_name, schema_name, graph, subquery_gsubs = [])
    @table_name = table_name
    @schema_name = schema_name
    @graph = graph
    @subquery_gsubs = subquery_gsubs
  end

  def queries
    sorted_grouped_edges.inject([]) do |memo, (_, edges)|
      memo += (EdgesToQueries.new(edges, table_name, schema_name, subquery_expander).queries)
      memo
    end
  end

  private

  def subquery_expander
    SubqueryExpander.new(table_name: table_name, schema_name: schema_name, subquery_gsubs: subquery_gsubs)
  end

  def sorted_grouped_edges
    Hash[grouped_edges.sort]
  end

  def grouped_edges
    graph.edges.group_by {|e| graph.longest_path(table_name, e.destination_vertex).length}
  end

end; end

