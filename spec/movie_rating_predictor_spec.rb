require_relative "../recommendation_engine/movie_rating_predictor"

describe MovieRatingPredictor do
  context ".movie_ratings_by_user" do
    it "fills info of movie ratings by given user" do
      movie_ratings = subject.movie_ratings_by_user(double)
      movie_ratings.should == { "movie1" => 1, "movie2" => 5 }
    end 
  end

  context ".users_ratings_for_movie" do
    it "fills info about users ratings for a given movie" do
      users_ratings = subject.users_ratings_for_movie(double)
      users_ratings.should == { "user1" => 2, "user2" => 4 }
    end
  end

  context ".calculate_predicted_rating" do
    let(:users_ratings) do
      {
        "user1" => 2,
        "user2" => 5, 
        "user3" => 1,
        "user4" => 3
      }
    end
    let(:similar_users) { ["user1", "user3"] }

    it "calculates predicted rating based on given user ratings" do
      predicted_rating = subject.
        calculate_predicted_rating(users_ratings, similar_users)
      predicted_rating.should == 1.5
    end
  end
end

class DataExtractor
  def self.movies_rated_by_user(user)
    yield "movie1", 1
    yield "movie2", 5
  end

  def self.user_ratings_for_movie(movie) 
    yield "user1", 2
    yield "user2", 4
  end
end
