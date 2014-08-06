require 'office_spec_helper'

describe 'Patient' do
  describe 'initialize' do
    it 'initializes a new patient' do
      new_patient = Patient.new({:name => "Austin", :birthday => "1900-01-01 00:00:00", :doctor_id => 2, :insurance_id => 1})
      expect(new_patient).to be_a Patient
      expect(new_patient.insurance_id).to eq 1
    end
  end

  describe "save" do
    it "saves a patient to the database" do
      test_patient = Patient.new({:name => "Austin", :birthday => "1900-01-01 00:00:00", :doctor_id => 2, :insurance_id => 1})
      test_patient.save
      expect(Patient.all).to eq [test_patient]
    end
  end

  describe ".all" do
    it "Lists all patients" do
      test_patient1 = Patient.new({:name => "Austin", :birthday => "1900-01-01 00:00:00", :doctor_id => 2, :insurance_id => 1})
      test_patient1.save
      test_patient2 = Patient.new({:name => "Moof", :birthday => "1950-12-01 00:00:00", :doctor_id => 1, :insurance_id => 3})
      test_patient2.save
      expect(Patient.all).to eq [test_patient1, test_patient2]
    end
  end

  describe "==" do
    it "sets two objects with same info as equal" do
      test_patient1 = Patient.new({:name => "Austin", :birthday => "1900-01-01 00:00:00", :doctor_id => 2, :insurance_id => 1})
      test_patient2 = Patient.new({:name => "Austin", :birthday => "1900-01-01 00:00:00", :doctor_id => 2, :insurance_id => 1})
      expect(test_patient1.==(test_patient2)).to be true
    end
  end

  describe "insurance_check" do
    it "tests whether there's a match between patient and doctor's insurance" do
      test_doctor1 = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 1})
      test_doctor1.save
      id1 = test_doctor1.id
      test_patient1 = Patient.new({:name => "Austin", :birthday => "1900-01-01 00:00:00", :doctor_id => id1, :insurance_id => 1})
      test_patient2 = Patient.new({:name => "Austin", :birthday => "1900-01-01 00:00:00", :doctor_id => id1, :insurance_id => 2})
      expect(test_patient1.insurance_check).to eq true
      expect(test_patient2.insurance_check).to eq false
    end
  end
end
