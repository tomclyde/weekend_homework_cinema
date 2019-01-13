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

  def buy_ticket(film_id, screening_id)
    sql = "SELECT tickets_available from screenings
           WHERE screenings.id = $1"
    values = [screening_id]
    tickets_left =  SqlRunner.run(sql, values).first['tickets_available'].to_i
    if tickets_left > 0
        if check_customer_has_enough_funds(film_id)
          sql = "UPDATE customers
          SET funds = funds - (SELECT sum(price)
              FROM films
              INNER JOIN tickets
              ON tickets.customer_id = $1
              WHERE tickets.film_id = $2
              AND films.id = $2)
              WHERE customers.id = $1"
          values = [@id, film_id]
          SqlRunner.run(sql, values)
        end
    end
  end

  def check_no_tickets_bought
    sql = "SELECT COUNT(tickets.*)
          FROM tickets
          WHERE tickets.customer_id = $1"
    values = [@id]
    return SqlRunner.run(sql, values).first['count'].to_i
  end

  def check_customer_has_enough_funds(film_id)
    sql = "SELECT customers.funds FROM customers
            WHERE customers.id = $1"
    values = [@id]
    funds =  SqlRunner.run(sql, values).first['funds'].to_f
    p funds

    sql = "SELECT films.price FROM films
            WHERE films.id = $1"
    values = [film_id]
    price =  SqlRunner.run(sql, values).first['price'].to_f
    p price

    if funds >= price
      return true
    else
      return false
    end
  end


end
