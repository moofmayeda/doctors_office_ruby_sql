require 'office_spec_helper'

describe 'Insurance' do
  describe 'initialize' do
    it 'initializes a new insurance' do
      new_insurance = Insurance.new({:name => "Blue Cross"})
      expect(new_insurance).to be_a Insurance
    end
  end

  describe "save" do
    it "saves a insurance to the database" do
      test_insurance = Insurance.new({:name => "Blue Cross"})
      test_insurance.save
      expect(Insurance.all).to eq [test_insurance]
    end
  end

  describe ".all" do
    it "Lists all specialties" do
      test_insurance1 = Insurance.new({:name => "Blue Cross"})
      test_insurance1.save
      test_insurance2 = Insurance.new({:name => "Kaiser"})
      test_insurance2.save
      expect(Insurance.all).to eq [test_insurance1, test_insurance2]
    end
  end

  describe "==" do
    it "sets two objects with same info as equal" do
      test_insurance1 = Insurance.new({:name => "Kaiser"})
      test_insurance2 = Insurance.new({:name => "Kaiser"})
      expect(test_insurance1.==(test_insurance2)).to be true
    end
  end
end
