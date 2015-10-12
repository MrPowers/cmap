require 'spec_helper'

module Cmap; describe EdgesToQueries do

  context "#expanded_graph" do
    it "returns all the graph vertices" do
      e1 = DirectedGraph::Edge.new(origin_vertex: "ov", value: "90D", destination_vertex: "dv")
      e2 = DirectedGraph::Edge.new(origin_vertex: "blah blah", value: "some query that isn't changed;", destination_vertex: "ok")

      subquery_gsubs = [["90D", "some +table_name+ from +destination_vertex+ to +origin_vertex+"]]

      expander = SubqueryExpander.new(table_name: "some_table", subquery_gsubs: subquery_gsubs)

      edges_to_queries = EdgesToQueries.new([e1, e2], "some_table", expander)
      expect(edges_to_queries.queries).to eq ["alter table some_table add column dv int2, add column ok int2;", "some some_table from dv to ov", "update some_table set ok=(some query that isn't changed;)::int;"]
    end
  end

end; end

