require 'spec_helper'

module Cmap; describe GraphToSql do

  context "#run_queries" do
    it "runs the queries in the right order" do
      propositions_path = File.expand_path("../support/human_lab_data_propositions.txt", File.dirname(__FILE__))
      prop = PropositionsToGraph.new(propositions_path)
      to_sql = GraphToSql.new("human_lab_data", prop.graph, {dbname: "messing_around"})

      to_sql.connection.exec("DROP TABLE IF EXISTS human_lab_data;")
      to_sql.connection.exec("CREATE TABLE human_lab_data ( age integer, nationality text );")
      to_sql.connection.exec("INSERT INTO human_lab_data (age, nationality) VALUES (66, 'american'), (69, 'american'), (30, 'german'), (15, 'crazy'), (99, 'ireland'), (100, 'finland');")

      to_sql.run_queries
    end

    it "runs complicated queries in the right order" do
      propositions_path = File.expand_path("../support/complicated_propositions.txt", File.dirname(__FILE__))
      prop = PropositionsToGraph.new(propositions_path)
      to_sql = GraphToSql.new("human_lab_data", prop.graph, {dbname: "messing_around"})

      to_sql.connection.exec("DROP TABLE IF EXISTS human_lab_data;")
      to_sql.connection.exec("CREATE TABLE human_lab_data ( age integer, nationality text );")
      to_sql.connection.exec("INSERT INTO human_lab_data (age, nationality) VALUES (66, 'american'), (69, 'american'), (30, 'german'), (15, 'crazy'), (99, 'ireland'), (100, 'finland');")

      to_sql.run_queries
    end
  end

end; end

