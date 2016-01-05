module Cmap; class PropositionsToSql

  attr_reader :propositions_path, :table_name, :schema_name, :subquery_gsubs

  def initialize(args)
    @propositions_path = args.fetch(:propositions_path)
    @table_name = args.fetch(:table_name)
    @schema_name = args.fetch(:schema_name)
    @subquery_gsubs = args.fetch(:subquery_gsubs, [])
  end

  def queries
    graph_to_sql.queries
  end

  def propositions_to_graph
    PropositionsToGraph.new(propositions_path)
  end

  def raw_graph
    propositions_to_graph.graph
  end

  def graph_to_sql
    GraphToSql.new(table_name, schema_name, raw_graph, subquery_gsubs)
  end

end; end

