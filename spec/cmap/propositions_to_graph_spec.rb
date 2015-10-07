require 'spec_helper'

module Cmap; describe PropositionsToGraph do

  context "#vertices" do
    it "returns all the graph vertices" do
      propositions_path = File.expand_path("../support/human_lab_data_propositions.txt", File.dirname(__FILE__))
      prop = PropositionsToGraph.new(propositions_path)
      expect(prop.graph.send(:vertices)).to match_array ["american", "human_lab_data", "kids", "senior_americans", "seniors"]
    end

    it "returns all the graph vertices when there are gsubs" do
      propositions_path = File.expand_path("../support/propositions_w_gsubs.txt", File.dirname(__FILE__))
      prop = PropositionsToGraph.new(propositions_path, [], [[/\s/, "_"]])
      expected = ["american", "human_lab_data", "kid_recently_created_american", "kids", "recently_created_american", "senior_americans", "seniors"]
      expect(prop.graph.send(:vertices)).to match_array expected
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

