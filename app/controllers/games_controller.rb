require 'open-uri'
require 'json'
require 'date'




class GamesController < ApplicationController

  def new
    @letters = (0...10).map { (65 + rand(26)).chr }
    return @letters
  end

  def rubynizer(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    check_word = open(url).read
    JSON.parse(check_word)
  end

  def hashinator(array_input)
    hash = Hash.new(0)
    array_input.each do |letter|
      hash[letter.downcase] += 1
    end
    hash
  end

  def score
    @attempt = params[:word]
    # retrieves the word's JSON as hash from the API
    @dict_check = rubynizer(@attempt)
    @score = @attempt.length * 2
    @word = @dict_check['word']

    # validate input
    word_chars = @word.downcase.chars
    grid = params[:grid].chars
    # letter count grid
    grid_hash = hashinator(grid)
    # letter count input
    input_hash = hashinator(word_chars)

    @message = ''
    if @dict_check.key?('error')
      @message = "Sorry, but '#{@word}' does not seem to be a valid English word. Try again"
      @score = 0
    else
      word_chars.each do |character|
        if grid_hash[character].to_i >= input_hash[character].to_i
          @message = "Congratulations! '#{@word}' is a valid English word."
        else
          @message = "Sorry, but '#{@word}' can not be build out of #{grid.join(', ')}."
          @score = 0
          break
        end
      end
    end
  end
end

# A page to display the game settings (random letters)
# with a form for the user to type a word. A button to submit this form.
# A page receiving this form, computing the user score and displaying it.
