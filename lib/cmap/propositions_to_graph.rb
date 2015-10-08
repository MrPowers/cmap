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

  # vertices from the text file that haven't been gsubbed
  def raw_vertices
    propositions.inject([]) do |m, (origin_vertex, _, destination_vertex)|
      m.push(origin_vertex, destination_vertex)
      m
    end.uniq
  end

  def sanitize_string(string)
    string.gsub(/[^0-9a-zA-Z]+/, '_').downcase
  end

  def gsubbed_value(value)
    raw_vertices.each do |raw_vertex|
      if value.include?(raw_vertex)
        value = value.gsub(raw_vertex, sanitize_string(raw_vertex))
      end
    end
    value
  end

  def edges
    @edges ||= propositions.inject([]) do |memo, e|
      origin_vertex, value, destination_vertex = e
      o = gsubber(vertex_gsubs, origin_vertex)
      d = gsubber(vertex_gsubs, destination_vertex)
      v = gsubbed_value(value)
      memo << DirectedGraph::Edge.new(o, d, v)
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
