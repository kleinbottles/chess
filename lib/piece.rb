# frozen_string_literal: true

module Chess
  # This is the parent class for all the pieces on the board
  class Piece
    attr_reader :color
    attr_accessor :pos

    def initialize(color, pos = nil)
      @color = color
      @pos = pos
    end

    def right_angle_lines(x, y, moves = [])
      7.times { |i| moves.push [(x + i + 1), y], [(x - i - 1), y], [x, (y + i + 1)], [x, (y - i - 1)] }
      moves.reject! { |move| move.any? { |space| space.negative? || space > 7 } }
      moves
    end

    def diagonal_lines(x, y, moves = [])
      7.times do |i|
        moves.push [(x + i + 1), (y + i + 1)], [(x - i - 1), (y - i - 1)],
                   [(x - i - 1), (y + i + 1)], [(x + i + 1), (y - i - 1)]
      end
      moves.reject! { |move| move.any? { |space| space.negative? || space > 7 } }
      moves
    end

    def adjacent_cells(x, y)
      moves = [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1],
               [x + 1, y + 1], [x - 1, y - 1], [x + 1, y - 1], [x - 1, y + 1]]
      moves.reject! { |move| move.any? { |space| space.negative? || space > 7 } }
      moves
    end

    def cell_ahead(x, y)
      black? ? [x, y + 1] : [x, y - 1]
    end

    def two_cells_ahead(x, y)
      black? ? [x, y + 2] : [x, y - 2]
    end

    def black?
      color == :black
    end

    def white?
      color == :white
    end
  end

  class Pawn < Piece
    attr_reader :symbol, :color
    attr_accessor :pos, :move_count

    def initialize(color, pos = nil, move_count = 0)
      super(color, pos)
      @move_count = move_count
      @symbol = color == :black ? "\u265f" : "\u2659"
    end

    def get_moves(position = pos)
      if move_count == 0
        [two_cells_ahead(position[0], position[1]), cell_ahead(position[0], position[1])]
      else
        [cell_ahead(position[0], position[1])]
      end
    end
  end

  class Rook < Piece
    attr_reader :symbol, :color
    attr_accessor :pos

    def initialize(color, pos = nil)
      super(color, pos)
      @symbol = color == :black ? "\u265c" : "\u2656"
    end

    def get_moves(position = pos)
      right_angle_lines(position[0], position[1])
    end
  end

  class Bishop < Piece
    attr_reader :symbol, :color
    attr_accessor :pos

    def initialize(color, pos = nil)
      super(color, pos)
      @symbol = color == :black ? "\u265d" : "\u2657"
    end

    def get_moves(position = pos)
      diagonal_lines(position[0], position[1])
    end
  end

  class Knight < Piece
    attr_reader :symbol, :color
    attr_accessor :pos

    def initialize(color, pos = nil)
      super(color, pos)
      @symbol = color == :black ? "\u265e" : "\u2658"
    end

    def get_moves(position = pos)
      x = position[0]
      y = position[1]
      moves = [[x + 2, y + 1], [x + 2, y - 1], [x - 2, y + 1], [x - 2, y - 1],
               [x + 1, y + 2], [x + 1, y - 2], [x - 1, y + 2], [x - 1, y - 2]]
      moves.reject! { |move| move.any? { |space| space.negative? || space > 7 } }
      moves
    end
  end

  class Queen < Piece
    attr_reader :symbol, :color
    attr_accessor :pos

    def initialize(color, pos = nil)
      super(color, pos)
      @symbol = color == :black ? "\u265b" : "\u2655"
    end

    def get_moves(position = pos)
      right_angle_lines(position[0], position[1]) + diagonal_lines(position[0], position[1])
    end
  end

  class King < Piece
    attr_reader :symbol, :color
    attr_accessor :pos

    def initialize(color, pos = nil)
      super(color, pos)
      @symbol = color == :black ? "\u265a" : "\u2654"
    end

    def get_moves(position = pos)
      adjacent_cells(position[0], position[1])
    end
  end
end
