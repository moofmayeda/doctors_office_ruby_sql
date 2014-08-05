class Doctor
  attr_accessor :name, :specialty_id, :insurance_id
  attr_reader :id

  def initialize doctor_info
    @name = doctor_info[:name]
    @specialty_id = doctor_info[:specialty_id]
    @insurance_id = doctor_info[:insurance_id]
  end

  def self.all
    doctors = []
    results = DB.exec("SELECT * FROM doctors;")
    results.each do |result|
      doctors << Doctor.new({:name => result['name'], :specialty_id => result['specialty_id'].to_i, :insurance_id => result['insurance_id'].to_i})
    end
    doctors
  end

  def save
    results = DB.exec("INSERT INTO doctors (name, specialty_id, insurance_id) VALUES ('#{@name}', #{@specialty_id}, #{@insurance_id}) RETURNING id;")
    @id = results.first['id'].to_i
  end

  def ==(other_doctor)
    self.name == other_doctor.name && self.specialty_id == other_doctor.specialty_id && self.insurance_id == other_doctor.insurance_id
  end

  def patient


  end
end
