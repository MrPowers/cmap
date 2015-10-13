require 'spec_helper'

module Cmap; describe GraphSanitizer do

  context "#sanitized_graph" do

    it "sanitizes the vertex names" do
      e1 = DirectedGraph::Edge.new(origin_vertex: "Origin, Vertex", value: "some connection stuff", destination_vertex: "Destination Vertex")
      e2 = DirectedGraph::Edge.new(origin_vertex: "blah blah", value: "connect", destination_vertex: "ooook")

      graph = DirectedGraph::Graph.new([e1, e2])
      sanitizer = GraphSanitizer.new(graph)

      new_vertices = sanitizer.sanitized_edges.map {|e| [e.origin_vertex, e.destination_vertex]}

      expect(new_vertices).to include ["origin_vertex", "destination_vertex"]
      expect(new_vertices).to include ["blah_blah", "ooook"]
    end
    
    it "its gsubs the edge value queries from the vertex names" do
      e1 = DirectedGraph::Edge.new(origin_vertex: "Origin, Vertex", value: "Origin, Vertex = 1", destination_vertex: "Destination Vertex")
      e2 = DirectedGraph::Edge.new(origin_vertex: "blah blah", value: "blah blah > 5", destination_vertex: "ooook")

      graph = DirectedGraph::Graph.new([e1, e2])
      sanitizer = GraphSanitizer.new(graph)

      expect(sanitizer.sanitized_edges[0].value).to eq "origin_vertex = 1"
      expect(sanitizer.sanitized_edges[1].value).to eq "blah_blah > 5"
    end
    
    it "gsubs queries in the proper precedence of more complex to less complex" do
      e1 = DirectedGraph::Edge.new(origin_vertex: "IGF-1 Result", value: "IGF-1 Result = 1 AND patient_gender = 'M'", destination_vertex: "IGF-1 Result, Male")
      e2 = DirectedGraph::Edge.new(origin_vertex: "IGF-1 Result", value: "IGF-1 Result = 1 AND patient_gender = 'F'", destination_vertex: "IGF-1 Result, Female")
      e3 = DirectedGraph::Edge.new(origin_vertex: "IGF-1 Result, Male", value: "IGF-1 Result, Male = 1", destination_vertex: "IGF-1 Result, Abn High, Male")

      graph = DirectedGraph::Graph.new([e1, e2, e3])
      sanitizer = GraphSanitizer.new(graph)

      expect(sanitizer.sanitized_edges[0].value).to eq "igf_1_result = 1 AND patient_gender = 'M'"
      expect(sanitizer.sanitized_edges[1].value).to eq "igf_1_result = 1 AND patient_gender = 'F'"
      expect(sanitizer.sanitized_edges[2].value).to eq "igf_1_result_male = 1"
    end

  end

end; end

