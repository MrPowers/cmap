module Cmap; class PropositionsToGraph

  attr_reader :propositions_path

  def initialize(propositions_path)
    @propositions_path = propositions_path
  end

  def graph
    Graph.new(vertices, edges)
  end

  private

  def propositions
    csv_path = File.expand_path(propositions_path, File.dirname(__FILE__))
    CSV.read(csv_path, { :col_sep => "\t", :quote_char => '"' })
  end

  def edges
    @edges ||= propositions.inject([]) do |memo, e|
      memo << Edge.new(*e)
      memo
    end
  end

  def vertices
    edges.inject([]) do |memo, e|
      memo.push(e.origin_vertex, e.destination_vertex)
      memo
    end.uniq
  end

end; end
