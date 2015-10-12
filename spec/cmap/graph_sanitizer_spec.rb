require 'spec_helper'

module Cmap; describe GraphSanitizer do

  context "#sanitized_graph" do

    it "runs queries with gsubs when needed" do
      e1 = DirectedGraph::Edge.new(origin_vertex: "Origin, Vertex", value: "some connection stuff", destination_vertex: "Destination Vertex")
      e2 = DirectedGraph::Edge.new(origin_vertex: "blah blah", value: "connect", destination_vertex: "ooook")

      graph = DirectedGraph::Graph.new([e1, e2])
      sanitizer = GraphSanitizer.new(graph)

      new_vertices = sanitizer.sanitized_edges.map {|e| [e.origin_vertex, e.destination_vertex]}

      expect(new_vertices).to include ["origin_vertex", "destination_vertex"]
      expect(new_vertices).to include ["blah_blah", "ooook"]

    end

  end

end; end

