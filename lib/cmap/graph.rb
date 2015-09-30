module Cmap

  class Edge

    attr_reader :origin_vertex, :destination_vertex, :value

    def initialize(origin_vertex, value, destination_vertex)
      @origin_vertex = origin_vertex
      @destination_vertex = destination_vertex
      @value = value
    end

  end


  class Graph

    attr_reader :vertices, :edges

    def initialize(vertices, edges)
      @vertices = vertices
      @edges = edges
    end

    def shortest_path(origin_vertex, destination_vertex)
      simple_graph.shortest_path(origin_vertex, destination_vertex)
    end

    private

    def simple_graph
      graph = SimpleGraph::Graph.new
      vertices.each do |v|
        graph.add_vertex(v)
      end
      edges.each do |e|
        graph.add_edge(e.origin_vertex, e.destination_vertex)
      end
      graph
    end

  end

end
