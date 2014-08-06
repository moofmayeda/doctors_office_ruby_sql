class Insurance
  attr_reader :id
  attr_accessor :name

  def initialize(name)
    @name = name[:name]
    @id = name[:id]
  end

  def self.all
    insurances = []
    results = DB.exec("SELECT * FROM insurance;")
    results.each do |result|
      insurances << Insurance.new({:id => result['id'], :name => result['name']})
    end
    insurances
  end

  def save
    results = DB.exec("INSERT INTO insurance (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def ==(other_insurance)
    self.name == other_insurance.name
  end

end
