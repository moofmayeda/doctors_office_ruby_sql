require 'office_spec_helper'

describe 'Specialty' do
  describe 'initialize' do
    it 'initializes a new specialty' do
      new_specialty = Specialty.new({:type => "Pediatrics"})
      expect(new_specialty).to be_a Specialty
    end
  end

  describe "save" do
    it "saves a specialty to the database" do
      test_specialty = Specialty.new({:type => "Pediatrics"})
      test_specialty.save
      expect(Specialty.all).to eq [test_specialty]
    end
  end

  describe ".all" do
    it "Lists all specialties" do
      test_specialty1 = Specialty.new({:type => "Pediatrics"})
      test_specialty1.save
      test_specialty2 = Specialty.new({:type => "Oncology"})
      test_specialty2.save
      expect(Specialty.all).to eq [test_specialty1, test_specialty2]
    end
  end

  describe "==" do
    it "sets two objects with same info as equal" do
      test_specialty1 = Specialty.new({:type => "Pediatrics"})
      test_specialty2 = Specialty.new({:type => "Pediatrics"})
      expect(test_specialty1.==(test_specialty2)).to be true
    end
  end
end
