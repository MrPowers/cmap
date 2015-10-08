module Cmap; class EdgesToQueries

  attr_reader :edges, :table_name, :query_gsubs

  def initialize(edges, table_name, query_gsubs)
    @edges = edges
    @table_name = table_name
    @query_gsubs = query_gsubs
  end

  def queries
    ["alter table #{table_name} #{add_columns_query};"] +
    gsub_subqueries +
    ["update #{table_name} set #{updates};"]
    .delete_if {|q| q.empty?}
  end

  private

  def unique_edges
    edges.uniq {|e| [e.destination_vertex, e.value]}
  end

  def add_columns_query
    unique_edges.map {|e| "add column #{e.destination_vertex} int2"}.join(", ")
  end

  def gsub_edges
    unique_edges.select { |e| query_gsubs.any? {|m, _| e.value.match(m)} }
  end

  def gsub_subqueries
    gsub_edges.map {|e| edge_to_subquery(e)}
  end

  def edge_to_subquery(edge)
    subquery = query_gsubs.find {|m, q| edge.value == m}[1]
    replacements = [["+table_name+", table_name], ["+destination_vertex+", edge.destination_vertex], ["+origin_vertex+", edge.origin_vertex]]
    replacements.each do |gsub|
      subquery = subquery.gsub(*gsub)
    end
    subquery
  end

  def updates
    (unique_edges - gsub_edges).map {|e| "#{e.destination_vertex}=(#{e.value})::int"}.join(", ")
  end

end; end

