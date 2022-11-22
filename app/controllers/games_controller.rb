
require 'json'
require 'open-uri'
require 'date'
class GamesController < ApplicationController
  def new
    @start_time = Time.now.to_i
    list = (1..10).to_a
    @random_list = list.map { ('a'..'z').to_a.sample }
  end

  def score
    score = 0
    random_list = params[:random_list].split(' ')
    word_list = params[:answer].chars
    time = Time.now.to_i - params[:start_time].to_i
    url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"
    word_serialized = URI.open(url).read
    info = JSON.parse(word_serialized)
    good_letter = true
    good_word = true
    word_list.each do |char|
      if random_list.include? char
        random_list.delete(char)
      else
        good_letter = false
      end
    end

    if info['found'] != true
      good_word = false
    end

    if good_letter && good_word
      score = (params[:answer].length * 100 / time)
      @message = "Well done - you scored #{score} points!"
    elsif good_letter && good_word == false
      @message = "Not allowed! Not a real word! You scored: #{score} points."
    else
      @message = "Not Allowed! Used letters not in the list! You scored #{score} points."
    end
  end
end
