require 'spec_helper'

module Cmap; describe PropositionsToSql do

  context "#queries" do

    it "generates queries" do
      propositions_path = File.expand_path("../support/propositions_w_subquery.txt", File.dirname(__FILE__))
      subquery = "update +table_name+ set +destination_vertex+=(select max(+origin_vertex+) FROM +table_name+ t2 where +table_name+.parent_id = t2.id)::int;"
      subquery_gsubs = [["parent_is", subquery]]
      propositions_to_sql = PropositionsToSql.new(propositions_path: propositions_path, table_name: "human_lab_data", subquery_gsubs: subquery_gsubs)

      expected = ["alter table human_lab_data add column kids int2;", "alter table human_lab_data add column irish int2;", "alter table human_lab_data add column seniors int2;", "alter table human_lab_data add column american int2;", "update human_lab_data set kids=(age < 18)::int, irish=(nationality = 'ireland')::int, seniors=(age > 65)::int, american=(nationality = 'american')::int;", "alter table human_lab_data add column senior_americans int2;", "alter table human_lab_data add column irish_parent int2;", "alter table human_lab_data add column american_parent int2;", "update human_lab_data set irish_parent=(select max(irish) FROM human_lab_data t2 where human_lab_data.parent_id = t2.id)::int;", "update human_lab_data set american_parent=(select max(american) FROM human_lab_data t2 where human_lab_data.parent_id = t2.id)::int;", "update human_lab_data set senior_americans=(seniors = 1 and american = 1)::int;", "alter table human_lab_data add column kid_with_irish_parent int2;", "alter table human_lab_data add column kid_with_american_parent int2;", "update human_lab_data set kid_with_irish_parent=(kids=1 AND irish_parent =1)::int, kid_with_american_parent=(kids=1 AND american_parent =1)::int;"]

      expect(propositions_to_sql.queries).to eq expected
    end

  end

end; end

