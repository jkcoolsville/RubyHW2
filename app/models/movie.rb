class Movie < ActiveRecord::Base
    def self.all_ratings
        eachRating = []
        Movie.all.each do |movie|
            if (eachRating.find_index(movie.rating) == nil)
                eachRating.push(movie.rating)
            end
        end
        return eachRating
    end
end
