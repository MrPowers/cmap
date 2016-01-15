require 'spec_helper'

module Cmap; describe PropositionsToGraph do

  let(:human_lab_data_propositions_path) { File.expand_path("../support/human_lab_data_propositions.txt", File.dirname(__FILE__)) }
  let(:other_human_lab_data_propositions_path) { File.expand_path("../support/other_human_lab_data_propositions.txt", File.dirname(__FILE__)) }

  context "#graph" do
    it "creates a graph" do
      prop = PropositionsToGraph.new(human_lab_data_propositions_path)
      expect(prop.graph).to be_instance_of DirectedGraph::Graph
    end
  end

  context "#vertices" do
    it "returns all the graph vertices" do
      prop = PropositionsToGraph.new(human_lab_data_propositions_path)
      vertices_names = ["american", "human_lab_data", "kids", "senior_americans", "seniors"]
      expected = vertices_names.map {|vertex_name| [vertex_name, vertex_name] }

      expect(vertex_to_string_array( prop.graph.send(:vertices) )).to match_array expected
    end

    it "returns all the graph vertices with other vertices" do
      prop = PropositionsToGraph.new(other_human_lab_data_propositions_path)
      vertices_names = ["american", "human_lab_data", "human lab data", "kid_recently_created_american", "kids", "recently_created_american", "recently created american", "senior_americans", "seniors"]
      expected = vertices_names.map {|vertex_name| [vertex_name, vertex_name] }

      expect(vertex_to_string_array( prop.graph.send(:vertices) )).to match_array expected
    end
  end

  private

  def vertex_to_string_array(vertex_array)
    vertex_array.map { |e| [e.name, e.data[:name]] }
  end

end; end
