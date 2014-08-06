class Doctor
  attr_accessor :name, :specialty_id, :insurance_id, :patients, :patient_count
  attr_reader :id

  def initialize doctor_info
    @name = doctor_info[:name]
    @specialty_id = doctor_info[:specialty_id]
    @insurance_id = doctor_info[:insurance_id]
    @id = doctor_info[:id]
    @patient_count = doctor_info[:patient_count]
  end

  def self.all
    doctors = []
    results = DB.exec("SELECT * FROM doctors;")
    results.each do |result|
      doctors << Doctor.new({:id => result['id'], :name => result['name'], :specialty_id => result['specialty_id'].to_i, :insurance_id => result['insurance_id'].to_i, :patient_count => result['patient_count']})
    end
    doctors
  end

  def self.remove(doctor_id)
    DB.exec("DELETE FROM doctors WHERE id = #{doctor_id}")
  end

  def save
    results = DB.exec("INSERT INTO doctors (name, specialty_id, insurance_id) VALUES ('#{@name}', #{@specialty_id}, #{@insurance_id}) RETURNING id;")
    @id = results.first['id'].to_i
  end

  def ==(other_doctor)
    self.name == other_doctor.name && self.specialty_id == other_doctor.specialty_id && self.insurance_id == other_doctor.insurance_id
  end

  def self.list_patients(id)
    @patients = []
    results = DB.exec("SELECT * FROM patients WHERE doctor_id = #{id};")
    results.each do |result|
      @patients << Patient.new({:name => result['name'], :birthday => result['birthday'], :doctor_id => result['doctor_id'].to_i, :insurance_id => result['insurance_id'].to_i})
    end
    @patients
  end

  def self.edit_insurance(id, new_insurance)
    DB.exec("UPDATE doctors SET insurance_id = #{new_insurance} WHERE id = #{id};")
  end

  def self.edit_specialty(id, new_specialty)
    DB.exec("UPDATE doctors SET specialty_id = #{new_specialty} WHERE id = #{id};")
  end

  def self.find_doctor(id)
    result = DB.exec("SELECT * FROM doctors WHERE id = #{id};").first
    doctor = Doctor.new({:id => result['id'], :name => result['name'], :specialty_id => result['specialty_id'].to_i, :insurance_id => result['insurance_id'].to_i, :patient_count => result['patient_count']})
  end

  def self.search_by_name(search)
    doctors = []
    results = DB.exec("SELECT * FROM doctors WHERE name LIKE '#{search}%';")
    results.each do |result|
      doctors << Doctor.new({:id => result['id'], :name => result['name'], :specialty_id => result['specialty_id'].to_i, :insurance_id => result['insurance_id'].to_i, :patient_count => result['patient_count']})
    end
    doctors
  end

  def self.search_by_insurance(search)
    doctors = []
    results = DB.exec("SELECT * FROM doctors WHERE insurance_id = #{search};")
    results.each do |result|
      doctors << Doctor.new({:id => result['id'], :name => result['name'], :specialty_id => result['specialty_id'].to_i, :insurance_id => result['insurance_id'].to_i, :patient_count => result['patient_count']})
    end
    doctors
  end

  def self.search_by_specialty(search)
    doctors = []
    results = DB.exec("SELECT * FROM doctors WHERE specialty_id = #{search};")
    results.each do |result|
      doctors << Doctor.new({:id => result['id'], :name => result['name'], :specialty_id => result['specialty_id'].to_i, :insurance_id => result['insurance_id'].to_i, :patient_count => result['patient_count']})
    end
    doctors
  end

  def self.count_patients(id)
    count = DB.exec("SELECT COUNT(*) FROM patients WHERE doctor_id = #{id};")
    count.first['count'].to_i
  end

  def update_count
    @patient_count = Doctor.count_patients(@id)
    DB.exec("UPDATE doctors SET patient_count = #{@patient_count} WHERE id = #{@id};")
  end
end
