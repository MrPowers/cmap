module Cmap; class SqlRunner

  attr_reader :db_config

  def initialize(db_config)
    @db_config = db_config
  end

  def run_queries(queries)
    queries.each do |q|
      connection.exec(q)
    end
  end

  def connection
    @connection ||= PGconn.connect(db_config)
  end

end; end


