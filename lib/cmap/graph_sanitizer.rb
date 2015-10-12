module Cmap; class GraphSanitizer

  attr_reader :graph

  def initialize(graph)
    @graph = graph
  end

  def sanitized_graph
    DirectedGraph::Graph.new(sanitized_edges)
  end

  def sanitized_data
    graph.edges.map do |edge|
      origin_vertex = sanitize_string(edge.origin_vertex)
      d = sanitize_string(edge.destination_vertex)
      {origin_vertex: origin_vertex, destination_vertex: d, value: edge.value}
    end
  end

  def sanitized_edges
    sanitized_data.map do |args|
      DirectedGraph::Edge.new(args)
    end
  end

  def sanitize_string(string)
    string.gsub(/[^0-9a-zA-Z]+/, '_').downcase
  end

end; end

