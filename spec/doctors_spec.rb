require 'office_spec_helper'

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

  describe "patients" do
    it "holds an array of patients of that doctor" do
      test_doctor = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      test_doctor.save
      id = test_doctor.id
      test_patient1 = Patient.new({:name => "Austin", :birthday => "1900-01-01 00:00:00", :doctor_id => id, :insurance_id => 1})
      test_patient1.save
      test_patient2 = Patient.new({:name => "Moof", :birthday => "1950-12-01 00:00:00", :doctor_id => id, :insurance_id => 2})
      test_patient2.save
      expect(test_doctor.patients) to eq [test_patient1, test_patient2]
    end
  end
end
