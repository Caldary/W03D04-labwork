require("pry")

require_relative("models/casting")
require_relative("models/movie")
require_relative("models/star")

Casting.delete_all()
Movie.delete_all()
Star.delete_all()

movie1 = Movie.new({"title" => "Blade", "genre" => "Action"})
movie1.save()
movie2 = Movie.new({"title" => "White Men Can't Jump", "genre" => "Comedy"})
movie2.save()

star1 = Star.new({"first_name" => "Wesley", "last_name" => "Snipes"})
star1.save()
star2 = Star.new({"first_name" => "Tara", "last_name" => "Reid"})
star2.save()
star3 = Star.new({"first_name" => "Kris", "last_name" => "Kristofferson"})
star3.save()

casting1 = Casting.new({"movie_id" => movie1.id, "star_id" => star1.id, "fee" => 5000000})
casting1.save()
casting2 = Casting.new({"movie_id" => movie2.id, "star_id" => star1.id, "fee" => 4000000})
casting2.save()
casting3 = Casting.new({"movie_id" => movie1.id, "star_id" => star3.id, "fee" => 3500000})
casting3.save()

binding.pry
nil