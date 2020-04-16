require_relative("../db/sql_runner")

class Movie
    attr_accessor :title, :genre
    attr_reader :id

    def initialize(hash)
        @id = hash["id"] if hash["id"]
        @title = hash["title"]
        @genre = hash["genre"]
    end

    def save()
        sql = "INSERT INTO movies (title, genre) VALUES ($1, $2) RETURNING id;"
        values = [@title, @genre]
        @id = SqlRunner.run(sql, values)[0]["id"].to_i
    end

    def delete()
        sql = "DELETE FROM movies WHERE id = $1;"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def update()
        sql = "UPDATE movies SET (title, genre) = ($1, $2) WHERE id = $3;"
        values = [@title, @genre, @id]
        SqlRunner.run(sql, values)
    end

    def stars()
        sql = "SELECT stars.* FROM stars 
        INNER JOIN castings ON stars.id = castings.star_id
        WHERE castings.movie_id = $1;"
        values = [@id]
        stars_array = SqlRunner.run(sql, values)
        return Star.map_items(stars_array)
    end

    def self.map_items(movies_array)
        return movies_array.map {|movie_hash| Movie.new(movie_hash)}
    end

    def self.all()
        movies_array = SqlRunner.run("SELECT * FROM movies;")
        return Movie.map_items(movies_array)
    end

    def self.delete_all()
        SqlRunner.run("DELETE FROM movies;")
    end

end
