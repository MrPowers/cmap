require 'spec_helper'

module Cmap; describe PropositionsToSql do

  context "#run_queries" do
    it "runs all the datamart queries" do
      # db setup
      connection = PGconn.connect
      connection.exec("DROP DATABASE IF EXISTS messing_around;")
      connection.exec("CREATE DATABASE messing_around;")
      connection = PGconn.connect(dbname: "messing_around")
      setup_database_path = File.expand_path("../support/setup_database.sql", File.dirname(__FILE__))
      setup_queries = File.readlines(setup_database_path).map! {|q| q.strip}.delete_if(&:empty?)
      setup_queries.each { |q| connection.exec(q) }

      # generate the profile
      propositions_path = File.expand_path("../support/human_lab_data_propositions.txt", File.dirname(__FILE__))
      prop = PropositionsToSql.new("human_lab_data", propositions_path, {dbname: "messing_around"})
      prop.run_queries

      # check the counts
      r = connection.client.query("select sum(seniors), sum(american), sum(kids), sum(senior_americans) from human_lab_data;").each(as: :array)
      expect(r).to eq ""
    end
  end

  context "#queries" do
    it "generates an array of the queries from the text file" do
      propositions_path = File.expand_path("../support/human_lab_data_propositions.txt", File.dirname(__FILE__))
      prop = PropositionsToSql.new("human_lab_data", propositions_path, {dbname: "messing_around"})
      expected = [
        "alter table human_lab_data add column kids int2;",
        "update human_lab_data set kids = 1 where (age < 12);",
        "alter table human_lab_data add column seniors int2;",
        "update human_lab_data set seniors = 1 where (age > 65);",
        "alter table human_lab_data add column american int2;",
        "update human_lab_data set american = 1 where (nationality = 'american');",
        "alter table human_lab_data add column senior_americans int2;",
        "update human_lab_data set senior_americans = 1 where (seniors = 1 and american = 1);"
      ]
      expect(prop.send(:queries)).to eq(expected)
    end
  end

end; end

