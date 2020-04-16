require_relative("../db/sql_runner")

class Star

    attr_accessor :first_name, :last_name
    attr_reader :id

    def initialize(hash)
        @id = hash["id"] if hash["id"]
        @first_name = hash["first_name"]
        @last_name = hash["last_name"]
    end

    def save()
        sql = "INSERT INTO stars (first_name, last_name) VALUES ($1, $2) RETURNING id;"
        values = [@first_name, @last_name]
        @id = SqlRunner.run(sql, values)[0]["id"].to_i
    end

    def delete()
        sql = "DELETE FROM stars WHERE id = $1;"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def update()
        sql = "UPDATE stars SET (first_name, last_name) = ($1, $2) WHERE id = $3;"
        values = [@first_name, @last_name, @id]
        SqlRunner.run(sql, values)
    end

    def movies()
        sql = "SELECT movies.* FROM movies 
        INNER JOIN castings ON movies.id = castings.movie_id
        WHERE castings.star_id = $1;"
        values = [@id]
        movies_array = SqlRunner.run(sql, values)
        return Movie.map_items(movies_array)
    end

    def self.map_items(stars_array)
        return stars_array.map {|star_hash| Star.new(star_hash)}
    end

    def self.all()
        stars_array = SqlRunner.run("SELECT * FROM stars;")
        return Star.map_items(stars_array)
    end

    def self.delete_all()
        SqlRunner.run("DELETE FROM stars;")
    end

end
