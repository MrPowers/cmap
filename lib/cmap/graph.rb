module Cmap

  class Graph

    attr_reader :vertices, :edges

    def initialize(vertices, edges)
      @vertices = vertices
      @edges = edges
    end

    def ordered_edges
      job_runner.execution_path.inject([]) do |memo, v|
        edge = edges.find {|e| e.destination_vertex == v}
        memo << edge if edge
        memo
      end
    end

    private

    def children(vertex)
      edges.select {|e| e.origin_vertex == vertex}.map{|e| e.destination_vertex}
    end

    def vertices_and_children
      vertices.map {|v| [v, children(v)]}
    end

    def job_runner
      runner = JobRunner.new
      vertices_and_children.each do |v, c|
        runner.add(v, c)
      end
      runner
    end

    def vertices_execution_path
      job_runner.execution_path
    end

  end

end
