# frozen_string_literal: true

require_relative 'game'



p1 = Chess::Player.new("nil")
p2 = Chess::Player.new("nil")
players = [p1, p2]
Chess::Game.new(players).start_game