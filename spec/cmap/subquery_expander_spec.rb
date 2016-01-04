require 'spec_helper'

module Cmap; describe SubqueryExpander do

  context "#expanded_graph" do
    it "returns all the graph vertices" do
      e1 = DirectedGraph::Edge.new(origin_vertex: "ov", value: "90D", destination_vertex: "dv")
      e2 = DirectedGraph::Edge.new(origin_vertex: "blah blah", value: "some query that isn't changed;", destination_vertex: "ooook")

      subquery_gsubs = [["90D", "some +table_name+ from +destination_vertex+ to +origin_vertex+"]]

      expander = SubqueryExpander.new(table_name: "some_table", schema_name: "some_schema", subquery_gsubs: subquery_gsubs)

      expect(expander.update_query?(e1)).to eq true
      expect(expander.update_query?(e2)).to eq false

      expect(expander.query(e1)).to eq "some some_table from dv to ov"
      expect(expander.query(e2)).to eq "some query that isn't changed;"
    end
  end

end; end

