require 'pg'
require './lib/doctors'
require './lib/patients'
require './lib/insurance'
require './lib/specialities'
require './lib/appointments'

DB = PG.connect({:dbname => 'office'})

def welcome
  puts "*"*88
  puts "Doctor's Office Admin Program"
  puts "*"*88
  main_menu
end

def main_menu
  puts "1 - Doctors"
  puts "2 - Patients"
  puts "3 - Add a specialty"
  puts "4 - Add an insurance company"
  puts "5 - Appointments"
  puts "6 - Exit"
  puts "Enter option number"
  case gets.chomp.to_i
  when 1
    doctors_menu
  when 2
    patients_menu
  when 3
    add_specialties
  when 4
    add_insurance
  when 5
    appointments_menu
  when 6
    exit
  else
    puts "Enter a valid option"
  end
    main_menu
end

def doctors_menu
  view_doctors
  puts "A - add a new doctor"
  puts "R - remove a doctor"
  puts "M - return to Main Menu"
  puts "S - search for a doctor"
  puts "Or enter the number of a doctor"
  response = gets.chomp.upcase
  case response
  when "A"
    add_doctor
  when "R"
    remove_doctor
  when "M"
    main_menu
  when "S"
    search_doctors_menu
  else
    doctor_menu(response.to_i)
  end
  doctors_menu
end

def search_doctors_menu
  puts "N - search by name"
  puts "I - search by insurance"
  puts "S - search by specialty"
  case gets.chomp.upcase
  when "N"
    doctor_name_search
  when "I"
    doctor_insurance_search
  when "S"
    doctor_specialty_search
  else
    puts "Try again."
    search_doctors_menu
  end
  doctors_menu
end

def doctor_name_search
  puts "Enter the name of the doctor"
  Doctor.search_by_name(gets.chomp.upcase).each do |doctor|
    puts "Name: " + doctor.name
    puts "Specialty ID: " + doctor.specialty_id.to_s
    puts "Accepted Insurance ID: " + doctor.insurance_id.to_s + "\n"
  end
end

def doctor_insurance_search
  view_insurance_id
  puts "Enter insurance ID number:"
  Doctor.search_by_insurance(gets.chomp).each do |doctor|
    puts "Name: " + doctor.name
    puts "Specialty ID: " + doctor.specialty_id.to_s
    puts "Accepted Insurance ID: " + doctor.insurance_id.to_s + "\n"
  end
end

def doctor_specialty_search
  view_specialties
  puts "Enter specialty ID number:"
  Doctor.search_by_specialty(gets.chomp).each do |doctor|
    puts "Name: " + doctor.name
    puts "Specialty ID: " + doctor.specialty_id.to_s
    puts "Accepted Insurance ID: " + doctor.insurance_id.to_s + "\n"
  end
end

def view_doctors
  puts "All doctors:"
  doctors = Doctor.all
  doctors.each do |doctor|
    puts doctor.id.to_s + ") " + doctor.name + " (Patients: " + doctor.patient_count.to_s + ")"
  end
end

def add_doctor
  puts "Enter name of doctor:"
  name = gets.chomp.upcase
  view_specialties
  puts "Please enter specialty ID:"
  s_id = gets.chomp.to_i
  view_insurance_id
  puts "Please enter insurance ID:"
  i_id = gets.chomp.to_i
  new_doctor = Doctor.new({:name => name,:specialty_id => s_id, :insurance_id => i_id})
  new_doctor.save
  puts "Doctor Added!"
end

def remove_doctor
  view_doctors
  puts "Enter the number of the doctor you'd like to remove"
  Doctor.remove(gets.chomp.to_i)
  puts "Doctor Removed!"
end

def view_specialties
  puts "Specialties:"
  Specialty.all.each do |specialty|
    puts specialty.id.to_s + ") " + specialty.type
  end
end

def view_insurance_id
  puts "Insurance Companies:"
  Insurance.all.each do |insurance|
    puts insurance.id.to_s + ") " + insurance.name
  end
end

def doctor_menu(id)
  doctor_info(id)
  puts "P - show patients"
  puts "I - edit/add insurance"
  puts "S - edit/add specialty"
  response = gets.chomp.upcase
  case response
  when 'P'
    show_patients(id)
  when 'I'
    edit_insurance(id)
  when 'S'
    edit_specialty(id)
  end
  doctor_menu(id)
end

def doctor_info(id)
  puts "Doctor information:"
  doctor = Doctor.find_doctor(id)
  puts "Name: " + doctor.name
  puts "Specialty ID: " + doctor.specialty_id.to_s
  puts "Accepted Insurance ID: " + doctor.insurance_id.to_s
  puts "Number of patients: " + doctor.patient_count.to_s
end

def show_patients(id)
  puts "Patients:"
  Doctor.list_patients(id).each do |patient|
    puts patient.name
    puts "birthday: " + patient.birthday
    puts "insurance id: " + patient.insurance_id.to_s
  end
end

def edit_insurance(id)
  view_insurance_id
  puts "Enter new insurance id"
  Doctor.edit_insurance(id, gets.chomp.to_i)
end

def edit_specialty(id)
  view_specialties
  puts "Enter new specialty id"
  Doctor.edit_specialty(id, gets.chomp.to_i)
end

def add_specialties
  view_specialties
  puts "Enter a new specialty"
  Specialty.new({:type => gets.chomp}).save
end

def add_insurance
  view_insurance_id
  puts "Enter a new insurance company name"
  Insurance.new({:name => gets.chomp}).save
end

def patients_menu
  puts "A - add a new patient"
  puts "S - search for a patient"
  puts "R - remove a patient"
  puts "M - return to Main Menu"
  response = gets.chomp.upcase
  case response
  when "A"
    add_patient
  when "R"
    patient = search_patient
    remove_patient(patient.id)
  when "M"
    main_menu
  when "S"
    patient = search_patient
    view_patient(patient)
    add_appointment(patient)
  else
    puts "try again"
  end
  patients_menu
end


def add_patient
  puts "Enter the name of the new patient"
  name = gets.chomp.upcase
  puts "Enter the patient's birthday (YYYY-MM-DD)"
  birthday = gets.chomp + " 00:00:00"
  view_insurance_id
  puts "Enter the patient's insurance ID"
  insurance = gets.chomp.to_i
  view_doctors
  puts "Enter the ID of the patient's doctor"
  doctor = gets.chomp.to_i
  new_patient = Patient.new({:name => name, :birthday => birthday, :doctor_id => doctor, :insurance_id => insurance})
  new_patient.save
  Doctor.find_doctor(doctor).update_count
  puts "Patient added!"
  puts "Note: doctor does not accept patient's insurance." if !new_patient.insurance_check
end

def remove_patient(patient_id)
  Patient.delete_patient(patient_id)
  puts "Patient Deleted!"
end

def search_patient
  puts "Enter the name of the patient:"
  Patient.search_by_name(gets.chomp.upcase)
end

def view_patient(patient)
  puts "Patient info:"
  puts " Name: " + patient.name
  puts " Birthday: " + patient.birthday[0..-10]
  puts " Doctor ID: " + patient.doctor_id.to_s
  puts " Insurance ID: " + patient.insurance_id.to_s + "\n"
  patient
end

def add_appointment(patient)
  puts "Enter 'y' to add a new appointment for this patient"
  if gets.chomp == 'y'
    puts "Enter the date of the appointment (YYYY-MM-DD)"
    date = gets.chomp
    puts "Enter the cost, if known"
    cost = gets.chomp.to_f
    new_appointment = Appointment.new({:patient_id => patient.id, :doctor_id => patient.doctor_id, :date => date, :cost => cost})
    new_appointment.save
    puts "New appointment added!"
  end
end

def appointments_menu
  puts "1) Make new appointment"
  puts "2) View/edit a patient's appointments"
  puts "3) View/edit a doctor's appointments"
  puts "4) View billing for a date range"
  case gets.chomp.to_i
  when 1
    patient = search_patient
    view_patient(patient)
    add_appointment(patient)
  when 2
    view_appointments_patient
    edit_date
    edit_cost
  when 3

  when 4

  end
  main_menu
end

def view_appointments_patient
  puts "Enter patient name"
  Appointment.find(gets.chomp).each do |appointment|
    puts appointment.id.to_s + ") Date: " + appointment.date
    puts "Cost: " + appointment.cost.to_s + "\n"
  end
end

def edit_date
  puts "Enter 'y' to change the date of an appointment"
  if gets.chomp == 'y'
    puts "Enter the appointment number"
    appointment = Appointment.find_by_id(gets.chomp.to_i)
    puts "Enter the new date (YYYY-MM-DD)"
    appointment.edit_date(gets.chomp)
    puts "Date changed!"
  end
end

def edit_cost
  puts "Enter 'y' to change the cost of an appointment"
  if gets.chomp == 'y'
    puts "Enter the appointment number"
    appointment = Appointment.find_by_id(gets.chomp.to_i)
    puts "Enter the new cost"
    appointment.edit_cost(gets.chomp.to_f)
    puts "Cost changed!"
  end
end
welcome
