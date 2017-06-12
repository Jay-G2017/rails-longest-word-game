# require 'open-uri'
# require 'json'

class WordGameController < ApplicationController

  def home
  end

  def game
    num = params[:num].to_i
    @grid = generate_grid(num)
  end

  def score
    @start_time = Time.parse(params[:start_time])
    @grid = params[:grid]
    @attempt = params[:result]
    @end_time = Time.now
    @result = run_game(@attempt, @grid, @start_time, @end_time)
  end

private

  def generate_grid(grid_size)
  # TODO: generate random grid of letters
  random_grid = []
  grid_size.times { random_grid << ("A".."Z").to_a.sample(1)[0] }
  return random_grid
  end

  def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  result_hash = {}
  result_hash[:time] = end_time - start_time
  key = "249b3261-4daf-4c78-b320-88bad24f27b2"
  uri = "https://api-platform.systran.net/translation/text/translate?input=#{attempt}&source=en&target=fr&key=#{key}"
  uri_response = open(uri).read
  response = uri_response
  translation = JSON.parse(response)["outputs"][0]["output"]
  if !included_in_grid?(attempt, grid)
    result_hash[:message] = "not in the grid"
    result_hash[:score] = 0
  elsif attempt == translation
    result_hash[:message] = "not an english word"
    result_hash[:score] = 0
  else
    result_hash[:translation] = translation
    result_hash[:score] = attempt.length + (1 / result_hash[:time])
    result_hash[:message] = "well done"
  end
  return result_hash
end

  def included_in_grid?(attempt, grid)
    attempt = attempt.upcase.split("")
    return attempt.all? { |word| attempt.count(word) <= grid.count(word) }
  end

end


