# frozen_string_literal: true

require_relative 'cell'
require_relative 'piece'

module Chess
  # The board class creates the board object which tracks the game state.
  class Board
    attr_reader :grid

    def initialize
      @grid = default_grid
    end

    def get_cell(x, y)
      grid[y][x]
    end

    def set_cell(x, y, value)
      get_cell(x, y).value = value
    end

    def move(starting_pos, ending_pos)
      return false unless legal_move?(starting_pos, ending_pos) && clear_path(starting_pos, ending_pos)

      set_cell(ending_pos[0], ending_pos[1], get_cell(starting_pos[0], starting_pos[1]).value)
      set_cell(starting_pos[0], starting_pos[1], nil)
    end

    def starting_board
      @grid[0][0].value, @grid[0][7].value = Rook.new(:black), Rook.new(:black)
      @grid[0][1].value, @grid[0][6].value = Knight.new(:black), Knight.new(:black)
      @grid[0][2].value, @grid[0][5].value = Bishop.new(:black), Bishop.new(:black)
      @grid[0][3].value, @grid[0][4].value = Queen.new(:black), King.new(:black)
      8.times do |space|
        grid[1][space].value = Pawn.new(:black)
      end

      @grid[7][0].value, @grid[7][7].value = Rook.new(:white), Rook.new(:white)
      @grid[7][1].value, @grid[7][6].value = Knight.new(:white), Knight.new(:white)
      @grid[7][2].value, @grid[7][5].value = Bishop.new(:white), Bishop.new(:white)
      @grid[7][3].value, @grid[7][4].value = Queen.new(:white), King.new(:white)
      8.times do |space|
        grid[6][space].value = Pawn.new(:white)
      end
    end

    def display_board
      grid.each do |row|
        puts row.map { |cell| cell.value == nil ? '_' : cell.value.symbol }.join(' ')
      end
    end

    private

    def default_grid
      Array.new(8) { Array.new(8) { Cell.new } }
    end

    def legal_move?(starting_pos, ending_pos)
      piece = get_piece(starting_pos)
      return true if piece.get_moves(starting_pos).include? ending_pos
    end

    def clear_path(starting_pos, ending_pos)
      piece = get_piece(starting_pos)
      # path is not clear if there is a piece on the ending position
      return false if get_piece(ending_pos)
      # the knight's path is clear if there is no piece on the final position
      return true if piece.instance_of?(Chess::Knight)

      # check horizontal lines
      if starting_pos[1] == ending_pos[1]
        if starting_pos[0] < ending_pos[0]
          ((starting_pos[0] + 1)..(ending_pos[0] + 1)).each do |space|
            return false if !get_cell(space, starting_pos[1]).value.nil?
          end
        else
          (starting_pos[0] - 1).downto(ending_pos[0]). each do |space|
            return false if !get_cell(space, starting_pos[1]).value.nil?
          end
        end
      # check vertical lines
      elsif starting_pos[0] == ending_pos[0]
        if starting_pos[1] < ending_pos[1]
          ((starting_pos[1] + 1)..(ending_pos[1] + 1)).each do |space|
            return false if !get_cell(starting_pos[0], space).value.nil?
          end
        else
          starting_pos[1].downto(ending_pos[1]). each do |space|
            return false if !get_cell(starting_pos[0], space).value.nil?
          end
        end
      else
        true
      end
    end

    def get_piece(pos)
      get_cell(pos[0], pos[1]).value
    end

  end
end
