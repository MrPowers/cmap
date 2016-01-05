module Cmap; class EdgesToQueries

  attr_reader :edges, :table_name, :schema_name, :subquery_expander

  def initialize(edges, table_name, schema_name, subquery_expander)
    @edges = edges
    @table_name = table_name
    @schema_name = schema_name
    @subquery_expander = subquery_expander
  end

  def queries
    add_columns_queries +
    gsub_subqueries +
    updates
    .delete_if {|q| q.empty?}
  end

  private

  def unique_edges
    edges.uniq {|e| [e.destination_vertex.data[:name], e.data[:value]]}
  end

  def add_columns_queries
    unique_edges.map {|e| "alter table #{schema_name}.#{table_name} add column #{e.destination_vertex.data[:name]} int2;"}
  end

  def grouped_edges
    unique_edges.group_by {|e| subquery_expander.update_query?(e)}
  end

  def gsub_subqueries
    (grouped_edges[true] || []).map {|e| subquery_expander.query(e)}
  end

  def updates
    u = (grouped_edges[false] || []).map {|e| "#{e.destination_vertex.data[:name]}=(#{e.data[:value]})::int"}.join(", ")
    return [] if u.empty?
    ["update #{schema_name}.#{table_name} set #{u};"]
  end

end; end

