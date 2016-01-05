module Cmap; class GraphSanitizer

  attr_reader :graph

  def initialize(graph)
    @graph = graph
    @sanitized_vertex_lookup = {}
  end

  def sanitize
    sanitize_vertices
    sanitize_edge_values
    graph
  end

  def sanitize_vertices
    graph.vertices.each do |v|
      s = sanitize_string(v.name)
      v.data[:sanitized_name] = s
      @sanitized_vertex_lookup[v.name] = s
    end
  end

  def sanitize_edge_values
    graph.edges.each do |edge|
      sanitized_value = ""
      @sanitized_vertex_lookup.keys.sort.reverse.each do |original_vertex_name|
        #edge.value = edge.value.gsub!(original_vertex_name, @sanitized_vertex_lookup[original_vertex_name])
        sanitized_value = sanitized_value.gsub!(original_vertex_name, @sanitized_vertex_lookup[original_vertex_name])
      end
      edge.data[:sanitized_value] = sanitized_value
    end
  end

  def sanitize_string(string)
    string.gsub(/[^0-9a-zA-Z]+/, '_').downcase
  end


  #def sanitized_graph
    #DirectedGraph::Graph.new(sanitized_edges)
  #end

  #def edges_with_sanitized_vertices
    #graph.edges.map do |edge|
      #origin_vertex = sanitize_string(edge.origin_vertex)
      #destination_vertex = sanitize_string(edge.destination_vertex)

      #@sanitized_vertex_lookup[edge.origin_vertex] = origin_vertex
      #@sanitized_vertex_lookup[edge.destination_vertex] = destination_vertex

      #{origin_vertex: origin_vertex, destination_vertex: destination_vertex, value: edge.value}
    #end
  #end

  #def sanitize_edge_value(edge_args)
    #@sanitized_vertex_lookup.keys.sort.reverse.each do |original_vertex_name|
      #edge_args[:value].gsub!(original_vertex_name, @sanitized_vertex_lookup[original_vertex_name])
    #end
    #edge_args
  #end

  #def sanitized_edges
    #edges_with_sanitized_vertices.map do |edge_args|
      #DirectedGraph::Edge.new(sanitize_edge_value(edge_args))
    #end
  #end

  #def sanitize_string(string)
    #string.gsub(/[^0-9a-zA-Z]+/, '_').downcase
  #end

end; end

