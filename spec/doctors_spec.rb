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

  describe ".remove" do
    it "Removes a doctor" do
      test_doctor = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      test_doctor.save
      Doctor.remove(test_doctor.id)
      expect(Doctor.all).to eq []
    end
  end

  describe "==" do
    it "sets two objects with same info as equal" do
      test_doctor1 = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      test_doctor2 = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      expect(test_doctor1.==(test_doctor2)).to be true
    end
  end

  describe ".list_patients" do
    it "holds an array of patients of that doctor" do
      test_doctor = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      test_doctor.save
      id = test_doctor.id
      test_patient1 = Patient.new({:name => "Austin", :birthday => "1900-01-01 00:00:00", :doctor_id => id, :insurance_id => 1})
      test_patient1.save
      test_patient2 = Patient.new({:name => "Moof", :birthday => "1950-12-01 00:00:00", :doctor_id => id, :insurance_id => 2})
      test_patient2.save
      expect(Doctor.list_patients(id)).to eq [test_patient1, test_patient2]
    end
  end

  describe ".edit_insurance" do
    it "updates insurance id given a doctor's id" do
      test_doctor = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      test_doctor.save
      id = test_doctor.id
      Doctor.edit_insurance(id, 3)
      expect(Doctor.all.first.insurance_id).to eq 3
    end
  end

  describe ".edit_specialty" do
    it "updates specialty id given a doctor's id" do
      test_doctor = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      test_doctor.save
      id = test_doctor.id
      Doctor.edit_specialty(id, 99)
      expect(Doctor.all.first.specialty_id).to eq 99
    end
  end

  describe ".find_doctor" do
    it "looks up a doctor by ID and returns the doctor object" do
      test_doctor = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      test_doctor.save
      id = test_doctor.id
      new_doctor = Doctor.find_doctor(id)
      expect(new_doctor.name).to eq "Eisenberg"
    end
  end

  describe ".search_by_name" do
    it "looks up a doctor by name and returns the matching doctors" do
      test_doctor = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      test_doctor.save
      expect(Doctor.search_by_name("Ei")).to eq [test_doctor]
    end
  end

  describe ".search_by_insurance" do
    it "looks up a doctor by insurance ID and returns the matching doctors" do
      test_doctor = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      test_doctor.save
      expect(Doctor.search_by_insurance(2)).to eq [test_doctor]
    end
  end

  describe ".search_by_specialty" do
    it "looks up a doctor by specialty ID and returns the matching doctors" do
      test_doctor = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      test_doctor.save
      expect(Doctor.search_by_specialty(3)).to eq [test_doctor]
    end
  end

  describe ".count_patients" do
    it "returns the number of patients of that doctor" do
      test_doctor = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      test_doctor.save
      id = test_doctor.id
      test_patient1 = Patient.new({:name => "Austin", :birthday => "1900-01-01 00:00:00", :doctor_id => id, :insurance_id => 1})
      test_patient1.save
      test_patient2 = Patient.new({:name => "Moof", :birthday => "1950-12-01 00:00:00", :doctor_id => id, :insurance_id => 2})
      test_patient2.save
      test_doctor.update_count
      expect(Doctor.count_patients(id)).to eq 2
      expect(test_doctor.patient_count).to eq 2
    end
  end
end
