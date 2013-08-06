# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.new(movie).save!
  end
end

Given /I check all ratings/ do
  step %Q[I check the following ratings: #{Movie.all_ratings.join(', ')}]
end

Given /I unchek all other but the following ratings: (.*)/ do |ratings|
  unchekRatins = Movie.all_ratings - ratings.split(', ')
  step %Q[I uncheck the following ratings: #{unchekRatins.join(', ')}]
end
# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  reg = Regexp.new(e1 + '[\s\S]+' + e2)
  assert reg =~ page.body, %Q[Shoud be "#{e1}" before "#{e2}"]
end

Then /I should see all movies sored by its release date/ do
  Movie.find(:all, :order => 'release_date').each_cons 2, do |movie1, movie2|
    step %Q[I should see "#{movie1.title}" before "#{movie2.title}"]
  end
end

Then /I should see all movies sorted by title/ do
  Movie.find(:all, :order => 'title ASC').each_cons 2, do |movie1, movie2|
    step %Q[I should see "#{movie1.title}" before "#{movie2.title}"]
  end
end

Then /I should see only the movies with the following ratings: (.*)/ do |rating_list|
  step %Q[I should see the movies with the following ratings: #{rating_list}]
  ratings_excludes = (Movie.all_ratings - rating_list.split(', ')).join(', ')
  step %Q[I should not see the movies with the following ratings: #{ratings_excludes}]
end

Then /I should not see the movies with the following ratings: (.*)/ do |rating_list|
  Movie.where('rating in (?)', rating_list).each do |movie|
    step %Q[I should not see "#movie.title"]
  end
end

Then /I should see the movies with the following ratings: (.*)/ do |rating_list|
  Movie.where('rating in (?)', rating_list.split(', ')).each do |movie|
    step %Q[I should see "#{movie.title}"]
  end
end

Then /I should see all of the movies/ do
  Movie.all.each do |movie|
    step %Q[I should see "#{movie.title}"]
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(', ').each do |rating|
    step %Q[I #{uncheck}check "#{rating}"]
  end
  # HINT: use String#split to split up the rating_list, then
  rating_list.split(', ').each do |rating|
    step %Q[I #{uncheck}check "ratings[#{rating}]"]
  end
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end
