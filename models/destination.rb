require_relative('../db/sql_runner.rb')

class Destination

  attr_accessor(:id, :destination_airport_name, :destination_city, :country)

  def initialize(options)
    @id = options['id'].to_i
    @destination_airport_name = options['destination_airport_name']
    @destination_city = options['destination_city']
    @country = options['country']
  end

  def self.all()
    sql = "SELECT * FROM destinations"
    values = []
    results = SqlRunner.run( sql, values )
    return results.map { |destination| Destination.new( destination ) }
  end

  def save()
    sql = "INSERT INTO destinations (destination_airport_name, destination_city, country)
           VALUES ($1, $2, $3)
           RETURNING id"
    values = [@destination_airport_name, @destination_city, @country]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  def delete()
    sql = "DELETE FROM destinations
    WHERE id = $1"
    values = [@id]
    SqlRunner.run( sql, values )
  end

  def self.delete_all()
    sql = "DELETE FROM destinations"
    values = []
    SqlRunner.run( sql, values )
  end

  def self.find(id)
    sql = "SELECT * FROM destinations
    WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values).first
    destination = Destination.new(result)
    return destination
  end

  def update()
    sql = "UPDATE destinations
          SET (destination_airport_name, destination_city, country) = ($1, $2, $3)
          WHERE id = $4"
    values = [@destination_airport_name, @destination_city, @country, @id]
    SqlRunner.run( sql, values)
  end

  def self.map_items(destination_data)
    return destination_data.map { |destination| Destination.new(destination) }
  end

end
