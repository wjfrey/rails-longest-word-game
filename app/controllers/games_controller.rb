require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
    @start_time = Time.current
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters]
    @start_time = params[:start_time]
    letter_test_array = params[:letters]

    @word.split('').each do |letter|
      if letter_test_array.include? letter
        letter_test_array.delete(letter)
      else
        @answer = 'array_missmatch'
        render 'score' and return
      end
    end

    if english_word?
      @answer = 'valid_english_word'
      @current_score = current_score
      old_score_total = session[:score] || 0
      session[:score] = old_score_total + @current_score
    end
  end

  private

  def english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    response = open(url)
    json = JSON.parse(response.read)
    json['found']
  end

  def current_score
    (@word.length * @word.length * 100) / seconds_elapsed   
  end

  def seconds_elapsed
    (Time.current - Time.parse(@start_time)).round
  end
end
