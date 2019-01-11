require_relative("../db/sql_runner")

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(customer_details)
    @id = customer_details['id'].to_i if customer_details['id']
    @name = customer_details['name']
    @funds = customer_details['funds']
  end


  def save()
    sql = "INSERT INTO customers
    (
      name,
      funds
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@name, @funds]
    customers = SqlRunner.run( sql, values ).first
    @id = customers['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM customers"
    values = []
    customers = SqlRunner.run(sql, values)
    result = customers.map { |customer| Customer.new( customer ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    values = []
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "
    UPDATE customers SET (
      name,
      funds
    ) =
    (
      $1,$2
    )
    WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql,values)
  end

  def delete()
    sql = "DELETE FROM customers where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.find(id)
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    customer_hash = results.first
    customer = Customer.new(customer_hash)
    return customer
  end

  def films_booked
    sql = "SELECT films.* FROM films, tickets
           WHERE tickets.customer_id = $1
           AND tickets.film_id = films.id"
    values = [@id]
    results = SqlRunner.run(sql, values)
    films = results.map { |result| Film.new( result ) }
    return films
  end

end
