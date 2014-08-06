class Appointment
  attr_accessor :patient_id, :doctor_id, :date, :cost
  attr_reader :id

  def initialize(details)
    @patient_id = details[:patient_id]
    @doctor_id = details[:doctor_id]
    @date = details[:date]
    @cost = details[:cost]
    @id = details[:id]
  end

  def self.all
    appointments = []
    results = DB.exec("SELECT * FROM appointments;")
    results.each do |result|
      appointments << Appointment.new({:id => result['id'].to_i, :patient_id => result['patient_id'].to_i, :doctor_id => result['doctor_id'].to_i, :date => result['date'], :cost => result['cost'].to_f})
    end
    appointments
  end

  def self.find(name)
    appointments = []
    results = DB.exec("SELECT * FROM patients INNER JOIN appointments ON patients.id=appointments.patient_id WHERE name LIKE '#{name}%';")
    results.each do |result|
      appointments << Appointment.new({:id => result['id'].to_i, :patient_id => result['patient_id'].to_i, :doctor_id => result['doctor_id'].to_i, :date => result['date'], :cost => result['cost'].to_f})
    end
    appointments
  end

  def self.find_by_id(id)
    result = DB.exec("SELECT * FROM appointments WHERE id = #{id};").first
    Appointment.new({:id => result['id'].to_i, :patient_id => result['patient_id'].to_i, :doctor_id => result['doctor_id'].to_i, :date => result['date'], :cost => result['cost'].to_f})
  end

  def self.find_by_doctor_id(doctor_id)
    appointments = []
    results = DB.exec("SELECT * FROM appointments WHERE doctor_id = #{doctor_id};")
    results.each do |result|
      appointments << Appointment.new({:id => result['id'].to_i, :patient_id => result['patient_id'].to_i, :doctor_id => result['doctor_id'].to_i, :date => result['date'], :cost => result['cost'].to_f})
    end
    appointments
  end

  def self.patient_bill(patient_id)
    DB.exec("SELECT SUM (cost) FROM appointments WHERE patient_id = #{patient_id};").first['sum'].to_f
  end

  def self.doctor_bill(doctor_id, date1, date2)
    DB.exec("SELECT SUM (cost) FROM appointments WHERE date BETWEEN '#{date1}' AND '#{date2}' AND doctor_id = #{doctor_id};").first['sum'].to_f
  end

  def save
    result = DB.exec("INSERT INTO appointments (patient_id, doctor_id, date, cost) VALUES (#{@patient_id}, #{@doctor_id}, '#{@date}', #{@cost}) RETURNING id;")
    @id = result.first['id'].to_i
  end

  def ==(another_appt)
    @patient_id == another_appt.patient_id && @doctor_id == another_appt.doctor_id && @date == another_appt.date && @cost == another_appt.cost
  end

  def edit_cost(new_cost)
    @cost = new_cost
    DB.exec("UPDATE appointments SET cost = #{new_cost} WHERE id = #{@id};")
  end

  def edit_date(new_date)
    @date = new_date
    DB.exec("UPDATE appointments SET date = '#{new_date}' WHERE id = #{@id};")
  end
end
