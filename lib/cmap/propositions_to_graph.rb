module Cmap; class PropositionsToGraph

  attr_reader :propositions_path

  def initialize(propositions_path)
    @propositions_path = propositions_path
  end

  def graph
    DirectedGraph::Graph.new(edges)
  end

  private

  def propositions
    csv_path = File.expand_path(propositions_path, File.dirname(__FILE__))
    CSV.read(csv_path, { :col_sep => "\t", :quote_char => '"' })
  end

  def edges
    @edges ||= propositions.inject([]) do |memo, e|
      origin_vertex, value, destination_vertex = e
      memo << DirectedGraph::Edge.new(origin_vertex, destination_vertex, value)
      memo
    end
  end

end; end
