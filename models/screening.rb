require_relative("../db/sql_runner")

class Screening

  attr_accessor :film_id, :screening_time, :tickets_available
  attr_reader :id

  def initialize(screening_details)
    @id = screening_details['id'].to_i if screening_details['id']
    @film_id = screening_details['film_id']
    @screening_time = screening_details['screening_time']
    @tickets_available = screening_details['tickets_available']
  end


  def save()
    sql = "INSERT INTO screenings
    (
      film_id,
      screening_time,
      tickets_available
    )
    VALUES
    (
      $1, $2, $3
    )
    RETURNING id"
    values = [@film_id, @screening_time, @tickets_available]
    screenings = SqlRunner.run( sql, values ).first
    @id = screenings['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    values = []
    screenings = SqlRunner.run(sql, values)
    result = screenings.map { |screening| screening.new( screening ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    values = []
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "
    UPDATE screenings SET (
      film_id,
      screening_time,
      tickets_available
    ) =
    (
      $1,$2,$3
    )
    WHERE id = $4"
    values = [@film_id, @screening_time, @tickets_available, @id]
    SqlRunner.run(sql,values)
  end

  def delete()
    sql = "DELETE FROM screenings where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.find(id)
    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    screening_hash = results.first
    screening = screening.new(screening_hash)
    return screening
  end


end
