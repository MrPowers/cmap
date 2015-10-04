require 'spec_helper'

module Cmap; describe PropositionsToGraph do

  context "#vertices" do
    it "returns all the graph vertices" do
      propositions_path = File.expand_path("../support/human_lab_data_propositions.txt", File.dirname(__FILE__))
      prop = PropositionsToGraph.new(propositions_path)
      expect(prop.graph.send(:vertices)).to match_array ["american", "human_lab_data", "kids", "senior_americans", "seniors"]
    end
  end

  context "#graph" do
    it "creates a graph" do
      propositions_path = File.expand_path("../support/human_lab_data_propositions.txt", File.dirname(__FILE__))
      prop = PropositionsToGraph.new(propositions_path)
      expect(prop.graph).to be_instance_of DirectedGraph::Graph
    end
  end

end; end

