module Cmap; class EdgesToQueries

  attr_reader :edges, :table_name, :subquery_expander

  def initialize(edges, table_name, subquery_expander)
    @edges = edges
    @table_name = table_name
    @subquery_expander = subquery_expander
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

  def grouped_edges
    unique_edges.group_by {|e| subquery_expander.update_query?(e)}
  end

  def gsub_subqueries
    (grouped_edges[true] || []).map {|e| subquery_expander.query(e)}
  end

  def updates
    (grouped_edges[false] || []).map {|e| "#{e.destination_vertex}=(#{e.value})::int"}.join(", ")
  end

end; end

