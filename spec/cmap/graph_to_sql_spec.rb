require 'spec_helper'

module Cmap; describe GraphToSql do

  context "#run_queries" do

    it "runs the queries in the right order" do
      propositions_path = File.expand_path("../support/human_lab_data_propositions.txt", File.dirname(__FILE__))
      propositions_to_sql = PropositionsToSql.new(propositions_path: propositions_path, table_name: "human_lab_data")

      runner = SqlRunner.new({dbname: "cmap_test"})
      connection = runner.connection

      seed_human_lab_data(connection)

      runner.run_queries(propositions_to_sql.queries)

      r = connection.exec("select sum(senior_americans) as old_people from human_lab_data;").first["old_people"]
      expect(r).to eq "2"
    end

    it "runs complicated queries in the right order" do
      propositions_path = File.expand_path("../support/complicated_propositions.txt", File.dirname(__FILE__))
      propositions_to_sql = PropositionsToSql.new(propositions_path: propositions_path, table_name: "human_lab_data")

      runner = SqlRunner.new({dbname: "cmap_test"})
      connection = runner.connection

      seed_human_lab_data(connection)

      runner.run_queries(propositions_to_sql.queries)

      r = connection.exec("select sum(kids_with_american_parents) as kids from human_lab_data;").first["kids"]
      expect(r).to eq "3"
    end

    it "runs queries with gsubs when needed" do
      propositions_path = File.expand_path("../support/propositions_w_subquery.txt", File.dirname(__FILE__))
      subquery = "update +table_name+ set +destination_vertex+=(select max(+origin_vertex+) FROM +table_name+ t2 where +table_name+.parent_id = t2.id)::int;"
      subquery_gsubs = [["parent_is", subquery]]
      propositions_to_sql = PropositionsToSql.new(propositions_path: propositions_path, table_name: "human_lab_data", subquery_gsubs: subquery_gsubs)

      runner = SqlRunner.new({dbname: "cmap_test"})
      connection = runner.connection

      seed_human_lab_data(connection)

      runner.run_queries(propositions_to_sql.queries)

      r = connection.exec("select sum(kid_with_american_parent) as kid_with_american_parent from human_lab_data;").first["kid_with_american_parent"]
      expect(r).to eq "2"
    end

  end

end; end

