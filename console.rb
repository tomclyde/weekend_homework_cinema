require("pry-byebug")
require_relative("./models/film")
require_relative("./models/customer")
require_relative("./models/ticket")


Film.delete_all()


film1 = Film.new({'title' => 'Ralph breaks the Internet', 'price' => 6.25})
film2 = Film.new({'title' => 'Mary Queen of Scots', 'price' => 8.50})
film3 = Film.new({'title' => 'The Grinch', 'price' => 0.50})

film1.save
film2.save
film3.save
