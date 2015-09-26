module Cmap; class PropositionsToSql

  attr_reader :table_name, :propositions_path, :db_config

  def initialize(table_name, propositions_path, db_config)
    @table_name = table_name
    @propositions_path = propositions_path
    @db_config = db_config
  end

  def propositions
    csv_path = File.expand_path(propositions_path, File.dirname(__FILE__))
    CSV.read(csv_path, { :col_sep => "\t", :quote_char => '"' })
  end

  def unique_propositions
    propositions.uniq {|_, q, col| [q, col]}
  end

  def queries
    r = []
    unique_propositions.each do |_, query, column|
      r.push("alter table #{table_name} add column #{column} int2;")
      r.push("update #{table_name} set #{column} = 1 where (#{query});")
    end
    r
  end

  def run_queries
    queries.each do |q|
      connection.exec(q)
    end
  end

  def connection
    PGconn.connect(db_config)
  end

end; end

