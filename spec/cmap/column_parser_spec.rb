require 'spec_helper'

module Cmap; describe ColumnParser do

  context "#column" do
    it "removes the denoted character and the subsequent text" do
      column_name = "value_total_:_real"
      cp = ColumnParser.new(column_name)

      expect(cp.column).to eql("value_total")
    end

    it "returns the original column name if no denoted character is found" do
      column_name = "value_total"
      cp = ColumnParser.new(column_name)

      expect(cp.column).to eql("value_total")
    end
  end

  context "#type" do
    it "defaults to int2 if no denoted character is found" do
      column_name = "value_total"
      cp = ColumnParser.new(column_name)

      expect(cp.type).to eql("int2")
    end

    it "defaults to the specified type if denoted character is found" do
      column_name = "value_total_:_real"
      cp = ColumnParser.new(column_name)

      expect(cp.type).to eql("real")
    end

    it "defaults to int2 if denoted character is found and no value is passed in after the denoted character" do
      column_name = "value_total_:_"
      cp = ColumnParser.new(column_name)

      expect(cp.type).to eql("int2")
    end
  end

end; end

