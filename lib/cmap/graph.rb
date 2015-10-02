module Cmap

  class Graph

    attr_reader :vertices, :edges

    def initialize(vertices, edges)
      @vertices = vertices
      @edges = edges
    end

    def ordered_edges
      sorted_vertices.inject([]) do |memo, v|
        edge = edges.find {|e| e.destination_vertex == v}
        memo << edge if edge
        memo
      end
    end

    private

    def sorted_vertices
      JobRunner.sorted_vertices(vertices_and_children)
    end

    def children(vertex)
      edges.select {|e| e.origin_vertex == vertex}.map{|e| e.destination_vertex}
    end

    def vertices_and_children
      vertices.map {|v| [v, children(v)]}
    end

  end

end
