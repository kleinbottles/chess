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
  end
end
