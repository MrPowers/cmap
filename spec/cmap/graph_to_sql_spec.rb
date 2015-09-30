require 'spec_helper'

module Cmap; describe GraphToSql do

  context "#run_queries" do
    it "runs the queries in the right order" do
      # db setup
      connection = PGconn.connect
      connection.exec("DROP DATABASE IF EXISTS messing_around;")
      connection.exec("CREATE DATABASE messing_around;")
      connection = PGconn.connect(dbname: "messing_around")
      connection.exec("CREATE TABLE human_lab_data ( age integer, nationality text );")
      connection.exec("INSERT INTO human_lab_data (age, nationality) VALUES (66, 'american'), (69, 'american'), (30, 'german'), (15, 'crazy'), (99, 'ireland'), (100, 'finland');")

      propositions_path = File.expand_path("../support/human_lab_data_propositions.txt", File.dirname(__FILE__))
      prop = PropositionsToGraph.new(propositions_path)
      to_sql = GraphToSql.new("human_lab_data", prop.graph, {dbname: "messing_around"})
      to_sql.run_queries
    end
  end

end; end

