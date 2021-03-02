# frozen_string_literal: true

require 'yaml'
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
      "\n#{current_player.name}: choose where to move your piece.\nEnter two coordinates separated by a space, or type \"SAVE\" to save your game.\n"
    end

    def get_move(move = gets.chomp)
      save_game if move.downcase == "save"

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

    def save_game
      directory = "../saved_games"
      Dir.mkdir(directory) unless Dir.exists?(directory)
      puts "Enter a name for your saved game:"
      name = gets.chomp
      filename = "../saved_games/#{name}.yaml"
      game = self.to_yaml
      File.open(filename, 'w') do |file|
        file.puts game
      end
      puts 'Game saved, see you soon!'
      exit
    end

    def load_game(game_name = return_picked_game)
      game = YAML.load(File.open("../saved_games/#{game_name}", 'r') do |file|
        file.read
      end)
      game.play
    end

    def get_saved_games
      games = Dir.entries "../saved_games"
      games.reject { |entry| File.directory?(entry) }
    end

    def list_saved_games
      get_saved_games.each_with_index { |game, index| puts "#{index + 1}: #{game}" }
    end

    def return_picked_game(human_choice = gets.chomp.to_i)
      games = get_saved_games
      return_picked_game unless human_choice.between?(1, games.length)

      games[human_choice - 1]
    end

    def play
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

    def start_game
      puts "Start a (n)ew game or (l)oad an old one!"
      answer = gets.chomp.downcase
      if answer.match("n")
        puts 'Enter player 1\'s name:'
        p1_name = gets.chomp
        puts 'Enter player 2\'s name:'
        p2_name = gets.chomp
        p1 = Chess::Player.new(p1_name)
        p2 = Chess::Player.new(p2_name)
        new_players = [p1, p2]
        new_game = Chess::Game.new(new_players)
        puts "#{new_game.current_player.name} has been randomly selected to play as white and will go first."
        new_game.board.starting_board
        return new_game.play
      elsif answer.match("l")
        begin
          list_saved_games
          puts "Enter the number for the game you want to load."
          load_game
        rescue
          puts "Looks like you don't have any saved games!"
          puts "Try typing (n) to start a new game."
          start_game
        end
      else
        puts "Enter (n) to start a new game, or (l) to load an old game."
        start_game
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

