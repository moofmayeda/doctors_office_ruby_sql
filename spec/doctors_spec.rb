require 'pg'
require 'rspec'
require 'doctors'

DB = PG.connect({:dbname => 'office_test'})

RSpec.configure do |config|
  config.before(:each) do
    DB.exec("DELETE FROM doctors *;")
    # DB.exec("DELETE FROM patients *;")
  end
end

describe "Doctor" do
  describe "initialize" do
    it "initializes a doctor with a hash of attributes" do
      test_doctor = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      expect(test_doctor).to be_a Doctor
    end
  end

  describe "save" do
    it "saves a doctor to the database" do
      test_doctor = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      test_doctor.save
      expect(Doctor.all).to eq [test_doctor]
    end
  end

  describe ".all" do
    it "Lists all doctors" do
      test_doctor1 = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      test_doctor1.save
      test_doctor2 = Doctor.new({:name => "Brown", :specialty_id => 5, :insurance_id => 1})
      test_doctor2.save
      expect(Doctor.all).to eq [test_doctor1, test_doctor2]
    end
  end

  describe "==" do
    it "sets two objects with same info as equal" do
      test_doctor1 = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      test_doctor2 = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      expect(test_doctor1.==(test_doctor2)).to be true
    end
  end
end
