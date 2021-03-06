require_relative('../db/sql_runner.rb')

class Departure

  attr_accessor( :id, :departure_airport_name, :departure_city, :dep_country)

  def initialize(options)
    @id = options['id'].to_i
    @departure_airport_name = options['departure_airport_name']
    @departure_city = options['departure_city']
    @dep_country = options['dep_country']
  end

  def self.all()
    sql = "SELECT * FROM departures"
    values = []
    results = SqlRunner.run( sql, values )
    return results.map { |departure| Departure.new( departure ) }
  end

  def save()
    sql = "INSERT INTO departures (departure_airport_name, departure_city, dep_country)
           VALUES ($1, $2, $3 )
           RETURNING id"
    values = [@departure_airport_name, @departure_city, @dep_country]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  def delete()
    sql = "DELETE FROM departures
    WHERE id = $1"
    values = [@id]
    SqlRunner.run( sql, values )
  end

  def self.delete_all()
    sql = "DELETE FROM departures"
    values = []
    SqlRunner.run( sql, values )
  end

  def self.find(id)
    sql = "SELECT * FROM departures
    WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values).first
    departure = Departure.new(result)
    return departure
  end

  def update()
    sql = "UPDATE departures
          SET (departure_airport_name, departure_city, dep_country) = ($1, $2, $3)
          WHERE id = $3"
    values = [@departure_airport_name, @departure_city, @dep_country, @id]
    SqlRunner.run( sql, values)
  end

  def self.map_items(departure_data)
    return departure_data.map { |departure| Departure.new(departure) }
  end

end
