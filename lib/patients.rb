class Patient
  attr_accessor :name, :birthday, :insurance_id, :doctor_id
  attr_reader :id

  def initialize(patient_info)
    @name = patient_info[:name]
    @birthday = patient_info[:birthday]
    @insurance_id = patient_info[:insurance_id]
    @doctor_id = patient_info[:doctor_id]
  end

  def self.all
    patients = []
    results = DB.exec("SELECT * FROM patients;")
    results.each do |result|
      patients << Patient.new({:name => result['name'], :birthday => result['birthday'], :doctor_id => result['doctor_id'].to_i, :insurance_id => result['insurance_id'].to_i})
    end
    patients
  end

  def save
    results = DB.exec("INSERT INTO patients (name, birthday, doctor_id, insurance_id) VALUES ('#{@name}', '#{@birthday}', #{@doctor_id}, #{@insurance_id}) RETURNING id;")
    @id = results.first['id'].to_i
  end

  def ==(other_patient)
    self.name == other_patient.name && self.birthday == other_patient.birthday && self.doctor_id == other_patient.doctor_id && self.insurance_id == other_patient.insurance_id
  end

end
