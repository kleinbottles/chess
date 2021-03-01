# frozen_string_literal: true

require_relative 'game'

puts 'Welcome to Command Line Chess.\n'
puts 'Enter player 1\'s name:'
p1_name = gets.chomp
puts 'Enter player 2\'s name:'
p2_name = gets.chomp

p1 = Chess::Player.new(p1_name)
p2 = Chess::Player.new(p2_name)
players = [p1, p2]
Chess::Game.new(players).play