module Cmap; class PropositionsToGraph

  attr_reader :propositions_path

  def initialize(propositions_path)
    @propositions_path = propositions_path
    @vertices = []
  end

  def graph
    DirectedGraph::Graph.new(edges)
  end

  private

  def edges
    @edges ||= propositions.inject([]) do |memo, e|
      origin_vertex_name, value, destination_vertex_name = e
      origin_vertex = find_vertex_or_create(origin_vertex_name)
      destination_vertex = find_vertex_or_create(destination_vertex_name)
      memo << DirectedGraph::Edge.new(origin_vertex: origin_vertex, destination_vertex: destination_vertex, value: value)
      memo
    end
  end

  def find_vertex_or_create(vertex_name)
    vertex = @vertices.find {|v| v.name == vertex_name}
    return vertex if vertex
    v = DirectedGraph::Vertex.new(name: vertex_name)
    @vertices << v
    v
  end

  def propositions
    csv_path = File.expand_path(propositions_path, File.dirname(__FILE__))
    CSV.read(csv_path, { :col_sep => "\t", :quote_char => '"' })
  end

end; end
