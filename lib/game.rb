# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

module Chess
  # The Game class manages the logic for the game, including
  # starting a new game, choosing players, and saving and loading a game.
  class Game
    attr_reader :players, :board, :current_player, :other_player

    def initialize(players, board = Board.new)
      @players = players
      @board = board
      @current_player, @other_player = players.shuffle
      current_player.color = :white
      other_player.color = :black
    end

    def switch_players
      @current_player, @other_player = @other_player, @current_player
    end

    def solicit_move
      "\n#{current_player.name}: choose where to move your piece.\nEnter two coordinates separated by a space.\n"
    end

    def get_move(move = gets.chomp)
      until move.match?(/[a-h][1-8][\s][a-h][1-8]/i)
        puts "Please enter two sets of alphanumeric coordinates separated by a space."
        move = gets.chomp
      end
      human_move_to_coordinates(move.downcase)
    end

    def game_over_message
      return "Checkmate. #{current_player.name} wins!"
    end

    def check_message
      return "#{other_player.name} is in check."
    end

    def play
      puts "#{current_player.name} has been randomly selected to play as white and will go first."
      board.starting_board
      while true
        board.display_board
        puts solicit_move
        starting_pos, ending_pos = get_move
        until board.can_accept_move?(starting_pos, ending_pos) && board.get_cell(starting_pos[0], starting_pos[1]).value&.color == current_player.color
          puts "Illegal move!"
          puts solicit_move
          starting_pos, ending_pos = get_move
        end
        board.move(starting_pos, ending_pos)
        if board.checkmate?(other_player.color)
          puts game_over_message
          board.display_board
          return
        elsif board.check?(other_player.color)
          puts check_message
          switch_players
        else
          switch_players
        end
      end
    end

    private

    def human_move_to_coordinates(human_move)
      mapping = {
        "a" => [0],
        "b" => [1],
        "c" => [2],
        "d" => [3],
        "e" => [4],
        "f" => [5],
        "g" => [6],
        "h" => [7],
        "1" => [0],
        "2" => [1],
        "3" => [2],
        "4" => [3],
        "5" => [4],
        "6" => [5],
        "7" => [6],
        "8" => [7]
      }
      divided_move = human_move.split('')
      [mapping[divided_move[0]] + mapping[divided_move[1]],
      mapping[divided_move[3]] + mapping[divided_move[4]]]
    end
  end
end

