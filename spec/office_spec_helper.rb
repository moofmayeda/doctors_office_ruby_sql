require 'pg'
require 'rspec'
require 'insurance'
require 'specialities'
require 'doctors'
require 'patients'
require 'appointments'

DB = PG.connect({:dbname => 'office_test'})

RSpec.configure do |config|
  config.before(:each) do
    DB.exec("DELETE FROM insurance *;")
    DB.exec("DELETE FROM specialty *;")
    DB.exec("DELETE FROM doctors *;")
    DB.exec("DELETE FROM patients *;")
    DB.exec("DELETE FROM appointments *;")
  end
end
