require 'office_spec_helper'

describe "Appointment" do
  describe "initialize" do
    it "initializes an appointment with a hash of details" do
      test_appointment = Appointment.new({:patient_id => 1, :doctor_id => 1, :date => "2014-08-01", :cost => 72.05})
      expect(test_appointment).to be_a Appointment
      expect(test_appointment.cost).to eq 72.05
      expect(test_appointment.date).to eq "2014-08-01"
    end
  end

  describe "save" do
    it "saves an appointment to the database" do
      test_appointment = Appointment.new({:patient_id => 1, :doctor_id => 1, :date => "2014-08-01", :cost => 72.05})
      test_appointment.save
      expect(Appointment.all).to eq [test_appointment]
    end
  end

  describe ".all" do
    it "Lists all appointments" do
      test_appointment1 = Appointment.new({:patient_id => 1, :doctor_id => 1, :date => "2014-08-01", :cost => 72.05})
      test_appointment1.save
      test_appointment2 = Appointment.new({:patient_id => 2, :doctor_id => 3, :date => "2014-08-01", :cost => 50.89})
      test_appointment2.save
      expect(Appointment.all).to eq [test_appointment1, test_appointment2]
    end
  end

  describe "==" do
    it "sets two objects with same info as equal" do
      test_appointment1 = Appointment.new({:patient_id => 1, :doctor_id => 1, :date => "2014-08-01", :cost => 72.05})
      test_appointment2 = Appointment.new({:patient_id => 1, :doctor_id => 1, :date => "2014-08-01", :cost => 72.05})
      expect(test_appointment1.==(test_appointment2)).to be true
    end
  end

  describe "edit_cost" do
    it "adds/changes the cost of the appointment" do
      test_appointment = Appointment.new({:patient_id => 1, :doctor_id => 1, :date => "2014-08-01", :cost => 72.05})
      test_appointment.save
      test_appointment.edit_cost(150.92)
      expect(test_appointment.cost).to eq 150.92
      expect(Appointment.all[0].cost).to eq 150.92
    end
  end

  describe "edit_date" do
    it "adds/changes the date of the appointment" do
      test_appointment = Appointment.new({:patient_id => 1, :doctor_id => 1, :date => "2014-08-01", :cost => 72.05})
      test_appointment.save
      test_appointment.edit_date("2014-08-20")
      expect(test_appointment.date).to eq "2014-08-20"
      expect(Appointment.all[0].date).to eq "2014-08-20"
    end
  end

  describe ".find" do
    it "returns all appointments for the given patient name" do
      test_patient = Patient.new({:name => "Moof", :birthday => "1950-12-01 00:00:00", :doctor_id => 1, :insurance_id => 3})
      test_patient.save
      patient_id = test_patient.id
      test_appointment1 = Appointment.new({:patient_id => patient_id, :doctor_id => 1, :date => "2014-08-01", :cost => 72.05})
      test_appointment1.save
      test_appointment2 = Appointment.new({:patient_id => patient_id, :doctor_id => 1, :date => "2014-08-20", :cost => 100.05})
      test_appointment2.save
      expect(Appointment.find("Moof")).to eq [test_appointment1, test_appointment2]
    end
  end

  describe ".find_by_id" do
    it "returns an appointment given an appointment id" do
      test_appointment = Appointment.new({:patient_id => 1, :doctor_id => 1, :date => "2014-08-01", :cost => 72.05})
      test_appointment.save
      id = test_appointment.id
      expect(Appointment.find_by_id(id)).to eq test_appointment
    end
  end

  describe ".find_by_doctor_id" do
    it "returns all appointments that a doctor has" do
      test_doctor = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      test_doctor.save
      id = test_doctor.id
      test_appointment1 = Appointment.new({:patient_id => 1, :doctor_id => id, :date => "2014-08-01", :cost => 72.05})
      test_appointment1.save
      test_appointment2 = Appointment.new({:patient_id => 1, :doctor_id => id, :date => "2014-08-20", :cost => 100.05})
      test_appointment2.save
      expect(Appointment.find_by_doctor_id(id)).to eq [test_appointment1, test_appointment2]
    end
  end
end
