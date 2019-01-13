require_relative("../db/sql_runner")

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(film_details)
    @id = film_details['id'].to_i if film_details['id']
    @title = film_details['title']
    @price = film_details['price']
  end


  def save()
    sql = "INSERT INTO films
    (
      title,
      price
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@title, @price]
    films = SqlRunner.run( sql, values ).first
    @id = films['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM films"
    values = []
    films = SqlRunner.run(sql, values)
    result = films.map { |film| Film.new( film ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    values = []
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "
    UPDATE films SET (
      title,
      price
    ) =
    (
      $1,$2
    )
    WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql,values)
  end

  def delete()
    sql = "DELETE FROM films where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.find(id)
    sql = "SELECT * FROM films WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    film_hash = results.first
    film = Film.new(film_hash)
    return film
  end

  def customers_viewing
    sql = "SELECT customers.* FROM customers, tickets
           WHERE tickets.film_id = $1
           AND tickets.customer_id = customers.id"
    values = [@id]
    results = SqlRunner.run(sql, values)
    customers = results.map { |result| Customer.new( result ) }
    return customers
  end

  def count_of_customers_viewing
    sql = "SELECT count(distinct (customers.*)) FROM customers, tickets
           WHERE tickets.film_id = $1
           AND tickets.customer_id = customers.id"
    values = [@id]
    return SqlRunner.run(sql, values).first['count'].to_i
  end

  def most_popular_time
    sql ="SELECT count(screenings.*),screenings.screening_time
          FROM screenings, films
          WHERE screenings.film_id = $1
          AND films.id = $1
          GROUP by screenings.screening_time"
          values = [@id]
    return SqlRunner.run(sql, values).first['screening_time']
  end
end
