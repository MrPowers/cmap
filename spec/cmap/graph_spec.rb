require 'spec_helper'

module Cmap; describe JobRunner do

  context "#vertices_execution_path" do
    it "organizes simple execution paths" do
      propositions_path = File.expand_path("../support/human_lab_data_propositions.txt", File.dirname(__FILE__))
      graph = PropositionsToGraph.new(propositions_path).graph
      expect(graph.vertices_execution_path).to eq ["human_lab_data", "american", "kids", "seniors", "senior_americans"]
    end

    it "organizes complicated execution paths" do
      propositions_path = File.expand_path("../support/complicated_propositions.txt", File.dirname(__FILE__))
      graph = PropositionsToGraph.new(propositions_path).graph
      expected = ["human_lab_data", "seniors", "american", "senior_americans", "american_parent_has", "kids", "kids_with_american_parents"]
      expect(graph.vertices_execution_path).to eq expected
    end
  end

end; end
