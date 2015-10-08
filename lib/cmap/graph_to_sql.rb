module Cmap; class GraphToSql

  attr_reader :table_name, :graph, :query_gsubs

  def initialize(table_name, graph, query_gsubs = [])
    @table_name = table_name
    @graph = graph
    @query_gsubs = query_gsubs
  end

  def queries
    edges = Hash[grouped_edges.sort]
    edges.inject([]) do |memo, (_, edges)|
      memo += (edges_to_queries(edges))
      memo
    end
  end

  private

  def grouped_edges
    graph.edges.group_by {|e| graph.longest_path(table_name, e.destination_vertex).length}
  end

  def edge_to_subquery(edge)
    subquery = query_gsubs.find {|m, q| edge.value == m}[1]
    replacements = [["+table_name+", table_name], ["+destination_vertex+", edge.destination_vertex], ["+origin_vertex+", edge.origin_vertex]]
    replacements.each do |gsub|
      subquery = subquery.gsub(*gsub)
    end
    subquery
  end

  def edges_to_queries(edges)
    # eliminate the duplicate edges
    unique_edges = edges.uniq {|e| [e.destination_vertex, e.value]}

    # create a string to add columns to the table
    add_columns = unique_edges.map {|e| "add column #{e.destination_vertex} int2"}.join(", ")

    # create special queries for the edges that need to be gsubbed
    gsub_edges = unique_edges.select { |e| query_gsubs.any? {|m, _| e.value.match(m)} }
    gsub_subqueries = gsub_edges.map {|e| edge_to_subquery(e)}

    # generate queries for the edges that don't need to be gsubbed
    updates = (unique_edges - gsub_edges).map {|e| "#{e.destination_vertex}=(#{e.value})::int"}.join(", ")

    # return an array of all the queries
    ["alter table #{table_name} #{add_columns};"] +
    gsub_subqueries +
    ["update #{table_name} set #{updates};"]
    .delete_if {|q| q.empty?}
  end

end; end

