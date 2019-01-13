require("pry-byebug")
require_relative("./models/film")
require_relative("./models/customer")
require_relative("./models/ticket")
require_relative("./models/screening")


Film.delete_all()


film1 = Film.new({'title' => 'Ralph breaks the Internet', 'price' => 6.25})
film2 = Film.new({'title' => 'Mary Queen of Scots', 'price' => 8.50})
film3 = Film.new({'title' => 'The Grinch', 'price' => 0.50})
film4 = Film.new({'title' => 'Jaws', 'price' => 23.75})

film1.save
film2.save
film3.save
film4.save

customer1 = Customer.new({'name' => 'Tom Clyde', 'funds' => 100.00})
customer2 = Customer.new({'name' => 'Louise Clyde', 'funds' => 8.00})
customer3 = Customer.new({'name' => 'Ryan Clyde', 'funds' => 0.25})

customer1.save
customer2.save
customer3.save

screening1 = Screening.new({'film_id' => film1.id,
                            'screening_time' => '12:00', 'tickets_available' => 0})

screening2 = Screening.new({'film_id' => film1.id,
                            'screening_time' => '12:00', 'tickets_available' => 20})

screening3 = Screening.new({'film_id' => film1.id,
                            'screening_time' => '15:00', 'tickets_available' => 20})

screening4 = Screening.new({'film_id' => film2.id,
                            'screening_time' => '19:00', 'tickets_available' => 20})

screening5 = Screening.new({'film_id' => film2.id,
                            'screening_time' => '21:00', 'tickets_available' => 2})


screening1.save
screening2.save
screening3.save
screening4.save
screening5.save

ticket1 = Ticket.new({'film_id' => film1.id, 'customer_id' => customer1.id,
                      'screening_id' => screening1.id})
ticket2 = Ticket.new({'film_id' => film1.id, 'customer_id' => customer1.id,
                      'screening_id' => screening1.id})
ticket3 = Ticket.new({'film_id' => film1.id, 'customer_id' => customer2.id,
                      'screening_id' => screening2.id})
ticket4 = Ticket.new({'film_id' => film2.id, 'customer_id' => customer2.id,
                      'screening_id' => screening4.id})
ticket5 = Ticket.new({'film_id' => film2.id, 'customer_id' => customer2.id,
                      'screening_id' => screening5.id})

ticket1.save
ticket2.save
ticket3.save
ticket4.save
ticket5.save


customer1.buy_ticket(1,1)




binding.pry
nil
