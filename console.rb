require("pry-byebug")
require_relative("./models/film")
require_relative("./models/customer")
require_relative("./models/ticket")


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

ticket1 = Ticket.new({'film_id' => film1.id, 'customer_id' => customer1.id})
ticket2 = Ticket.new({'film_id' => film1.id, 'customer_id' => customer1.id})
ticket3 = Ticket.new({'film_id' => film1.id, 'customer_id' => customer2.id})
ticket4 = Ticket.new({'film_id' => film2.id, 'customer_id' => customer2.id})
ticket5 = Ticket.new({'film_id' => film4.id, 'customer_id' => customer2.id})

ticket1.save
ticket2.save
ticket3.save
ticket4.save
ticket5.save
