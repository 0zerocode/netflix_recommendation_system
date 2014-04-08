class RatingPredictor
  def initialize
    @user_ratings_dir = "../sample_netflix_dataset/user_ratings/"
    @users_ids_file   = "../sample_netflix_dataset/users"
    @movies_dir       = "../sample_netflix_dataset/movies/"
  end

  def predict(user, movie)
    movies = movies_rated_by_user(user)
    users = users_ratings_for_movie(movie)
    #users.each { |u| ratings_of_similar_movies_by_both_users(user, u) }
  end

  def movies_rated_by_user(user)
    command = %Q{ tail -n+2 #{@user_ratings_dir}/#{user}_ratings }
    ratings = `#{command}`.split("\n")
    ratings = ratings.select { |rating| rating =~ /.*:.*/ }
    movie_ratings = {}
    ratings.each do |rating|
      movie, rating = rating.split(":")[0], rating.split(":")[1].to_i
      movie_ratings[movie] = rating
    end
    movie_ratings
  end

  def users_ratings_for_movie(movie)
    command = %Q{ls #{@user_ratings_dir} | while read rating_file; do grep -m 1 "\\b#{movie}:" #{@user_ratings_dir}$rating_file /dev/null; done}
    users_rating_info = `#{command}`.split("\n")
    users_ratings = {}
    users_rating_info.each do |rating_info|
      user_id, rate_value = extract_user_id_and_rating_value(rating_info)
      users_ratings[user_id] = rate_value
    end
    users_ratings
  end

  def extract_user_id_and_rating_value(user_rating_file_and_rating_info)
    rating_filepath = user_rating_file_and_rating_info.split(":")[0]
    rate_value      = user_rating_file_and_rating_info.split(":")[2].to_i
    rating_filename = rating_filepath.split("/")[3]
    user_id         = rating_filename.gsub(/_ratings/, "")
    return user_id, rate_value
  end
end

print RatingPredictor.new.movies_rated_by_user("1003353")
puts
# "0008387"
