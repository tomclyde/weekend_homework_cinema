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
