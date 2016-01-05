module Cmap; class SubqueryExpander

  attr_reader :table_name, :schema_name, :subquery_gsubs

  def initialize(args)
    @table_name = args.fetch(:table_name)
    @schema_name = args.fetch(:schema_name)
    @subquery_gsubs = args.fetch(:subquery_gsubs, [])
  end

  def update_query?(edge)
    edge.data[:value] != query(edge)
  end

  def query(edge)
    r = edge.data[:value]
    replacements = [
      ["+table_name+", table_name],
      ["+schema_name+", schema_name],
      ["+destination_vertex+", edge.destination_vertex.data[:name]],
      ["+origin_vertex+", edge.origin_vertex.data[:name]]
    ]
    (subquery_gsubs + replacements).each {|gsub| r = r.gsub(*gsub)}
    r
  end

end; end

