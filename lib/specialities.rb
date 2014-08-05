class Specialty
  attr_reader :id
  attr_accessor :type

  def initialize(type)
    @type = type[:type]
  end

  def self.all
    specialty = []
    results = DB.exec("SELECT * FROM specialty;")
    results.each do |result|
      specialty << Specialty.new({:type => result['type']})
    end
    specialty
  end

  def save
    results = DB.exec("INSERT INTO specialty (type) VALUES ('#{@type}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def ==(other_specialty)
    self.type == other_specialty.type
  end

end
