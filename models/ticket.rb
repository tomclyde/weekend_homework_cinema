require_relative("../db/sql_runner")

class Ticket

  attr_reader :id
  attr_accessor :film_id, :customer_id

  def initialize( ticket_details )
    @id = ticket_details['id'].to_i if ticket_details['id']
    @film_id = ticket_details['film_id'].to_i
    @customer_id = ticket_details['customer_id'].to_i
  end

  def save()
    sql = "INSERT INTO tickets
    (
      film_id,
      customer_id
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@film_id, @customer_id]
    tickets = SqlRunner.run( sql,values ).first
    @id = tickets['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql)
    result = tickets.map { |ticket| Ticket.new( ticket ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def update()
    sql = "
    UPDATE tickets SET (
      film_id,
      customer_id
    ) =
    (
      $1,$2
    )
    WHERE id = $3"
    values = [@film_id, @customer_id, @id]
    SqlRunner.run(sql,values)
  end

  def delete()
    sql = "DELETE FROM tickets where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.find(id)
    sql = "SELECT * FROM tickets WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    ticket_hash = results.first
    ticket = Ticket.new(ticket_hash)
    return ticket
  end

end
