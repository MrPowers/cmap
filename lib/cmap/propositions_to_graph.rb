module Cmap; class PropositionsToGraph

  attr_reader :propositions_path, :vertex_gsubs

  def initialize(propositions_path, vertex_gsubs = [])
    @propositions_path = propositions_path
    @vertex_gsubs = vertex_gsubs
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
      o = gsubber(vertex_gsubs, origin_vertex)
      d = gsubber(vertex_gsubs, destination_vertex)
      memo << DirectedGraph::Edge.new(o, d, value)
      memo
    end
  end

  def gsubber(gsubs, string)
    gsubs.each do |gsub|
      string = string.gsub(*gsub)
    end
    string
  end

end; end
