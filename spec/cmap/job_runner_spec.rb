require 'spec_helper'

module Cmap; describe JobRunner do

  context "#vertices_execution_path" do
    it "organizes the vertices by order of execution" do
      args = [
        ["human_lab_data", ["kids", "american", "seniors"]],
        ["kids", ["kids_with_american_parents"]],
        ["seniors", ["senior_americans"]],
        ["senior_americans", []],
        ["american", ["american_parent_has", "senior_americans"]],
        ["american_parent_has", ["kids_with_american_parents"]],
        ["kids_with_american_parents", []]
      ]
      runner = JobRunner.new
      args.each do |v, c|
        runner.add(v, c)
      end
      expected = ["kids_with_american_parents", "kids", "american_parent_has", "senior_americans", "american", "seniors", "human_lab_data"]
      expect(runner.execute).to eq expected
    end
  end

end; end

