require_relative("../db/sql_runner")

class Casting

    attr_accessor :movie_id, :star_id, :fee
    attr_reader :id

    def initialize(hash)
        @id = hash["id"] if hash["id"]
        @movie_id = hash["movie_id"]
        @star_id = hash["star_id"]
        @fee = hash["fee"]
    end
    
    def save()
        sql = "INSERT INTO castings (movie_id, star_id, fee) VALUES ($1, $2, $3) RETURNING id;"
        values = [@movie_id, @star_id, @fee]
        @id = SqlRunner.run(sql, values)[0]["id"].to_i
    end

    def delete()
        sql = "DELETE FROM castings WHERE id = $1;"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def update()
        sql = "UPDATE castings SET (movie_id, star_id, fee) = ($1, $2, $3) WHERE id = $4;"
        values = [@movie_id, @star_id, @fee, @id]
        SqlRunner.run(sql, values)
    end

    def star()
        sql = "SELECT * FROM stars WHERE id = $1;"
        values = [@star_id]
        star_hash = SqlRunner.run(sql, values).first()
        return Star.new(star_hash)
    end

    def movie()
        sql = "SELECT * FROM movies WHERE id = $1;"
        values = [@movie_id]
        movie_hash = SqlRunner.run(sql, values).first()
        return Movie.new(movie_hash)
    end

    def self.map_items(castings_array)
        return castings_array.map {|casting_hash| Casting.new(casting_hash)}
    end

    def self.all()
        castings_array = SqlRunner.run("SELECT * FROM castings;")
        return Casting.map_items(castings_array)
    end

    def self.delete_all()
        SqlRunner.run("DELETE FROM castings;")
    end

end
