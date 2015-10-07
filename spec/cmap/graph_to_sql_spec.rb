require 'spec_helper'

module Cmap; describe GraphToSql do

  context "#run_queries" do

    it "runs the queries in the right order" do
      propositions_path = File.expand_path("../support/human_lab_data_propositions.txt", File.dirname(__FILE__))
      prop = PropositionsToGraph.new(propositions_path)
      to_sql = GraphToSql.new("human_lab_data", prop.graph, )
      runner = SqlRunner.new({dbname: "cmap_test"})
      connection = runner.connection

      seed_human_lab_data(connection)

      runner.run_queries(to_sql.queries)

      r = connection.exec("select sum(senior_americans) as old_people from human_lab_data;").first["old_people"]
      expect(r).to eq "2"
    end

    it "runs complicated queries in the right order" do
      propositions_path = File.expand_path("../support/complicated_propositions.txt", File.dirname(__FILE__))
      prop = PropositionsToGraph.new(propositions_path)
      to_sql = GraphToSql.new("human_lab_data", prop.graph)
      runner = SqlRunner.new({dbname: "cmap_test"})
      connection = runner.connection

      seed_human_lab_data(connection)

      runner.run_queries(to_sql.queries)

      r = connection.exec("select sum(kids_with_american_parents) as kids from human_lab_data;").first["kids"]
      expect(r).to eq "3"
    end

    it "runs queries with gsubs when needed" do
      propositions_path = File.expand_path("../support/propositions_w_gsubs.txt", File.dirname(__FILE__))
      today = "'2015-01-01'"
      query_gsubs = [["90D", "created_at > DATE(#{today}) - interval '90' day"]]
      column_gsubs = [[/\s/, "_"]]
      prop = PropositionsToGraph.new(propositions_path, query_gsubs, column_gsubs)
      to_sql = GraphToSql.new("human_lab_data", prop.graph)

      runner = SqlRunner.new({dbname: "cmap_test"})
      connection = runner.connection

      seed_human_lab_data(connection)

      runner.run_queries(to_sql.queries)

      r = connection.exec("select sum(kid_recently_created_american) as american_kids from human_lab_data;").first["american_kids"]
      expect(r).to eq "2"
    end

  end

end; end

