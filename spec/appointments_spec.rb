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

  describe ".patient_bill" do
    it "returns the total amount billed to a patient" do
      test_patient = Patient.new({:name => "Moof", :birthday => "1950-12-01 00:00:00", :doctor_id => 1, :insurance_id => 3})
      test_patient.save
      patient_id = test_patient.id
      test_appointment1 = Appointment.new({:patient_id => patient_id, :doctor_id => 1, :date => "2014-08-01", :cost => 72.05})
      test_appointment1.save
      test_appointment2 = Appointment.new({:patient_id => patient_id, :doctor_id => 1, :date => "2014-08-20", :cost => 100.05})
      test_appointment2.save
      expect(Appointment.patient_bill(patient_id)).to eq 172.10
    end
  end

  describe ".doctor_bill" do
    it "returns the total amount billed by a doctor in a given date range" do
      test_doctor = Doctor.new({:name => "Eisenberg", :specialty_id => 3, :insurance_id => 2})
      test_doctor.save
      id = test_doctor.id
      test_doctor2 = Doctor.new({:name => "MKN", :specialty_id => 3, :insurance_id => 1})
      test_doctor2.save
      id2 = test_doctor2.id
      test_appointment1 = Appointment.new({:patient_id => 1, :doctor_id => id, :date => "2014-08-01", :cost => 72.05})
      test_appointment1.save
      test_appointment2 = Appointment.new({:patient_id => 1, :doctor_id => id, :date => "2014-08-10", :cost => 100.05})
      test_appointment2.save
      test_appointment3 = Appointment.new({:patient_id => 1, :doctor_id => id, :date => "2014-08-20", :cost => 50.00})
      test_appointment3.save
      test_appointment4 = Appointment.new({:patient_id => 1, :doctor_id => id2, :date => "2014-08-05", :cost => 1000.00})
      test_appointment4.save
      expect(Appointment.doctor_bill(id, "2014-07-30", "2014-08-15")).to eq 172.10
      expect(Appointment.doctor_bill(id, "2014-08-05", "2014-08-25")).to eq 150.05
    end
  end
end
