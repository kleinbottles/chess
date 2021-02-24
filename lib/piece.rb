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
    end

    def cell_ahead(x, y)
      black? ? [x, y + 1] : [x, y - 1]
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
    attr_accessor :pos

    def initialize(color, pos = nil)
      super(color, pos)
      @symbol = color == :black ? "\u265f" : "\u2659"
    end

    def get_moves(pos)
      [cell_ahead(pos[0], pos[1])]
    end
  end

  class Rook < Piece
    attr_reader :symbol, :color
    attr_accessor :pos

    def initialize(color, pos = nil)
      super(color, pos)
      @symbol = color == :black ? "\u265c" : "\u2656"
    end

    def get_moves(pos)
      right_angle_lines(pos[0], pos[1])
    end
  end

  class Bishop < Piece
    attr_reader :symbol, :color
    attr_accessor :pos

    def initialize(color, pos = nil)
      super(color, pos)
      @symbol = color == :black ? "\u265d" : "\u2657"
    end

    def get_moves(pos)
      diagonal_lines(pos[0], pos[1])
    end
  end

  class Knight < Piece
    attr_reader :symbol, :color
    attr_accessor :pos

    def initialize(color, pos = nil)
      super(color, pos)
      @symbol = color == :black ? "\u265e" : "\u2658"
    end

    def get_moves(pos)
      x = pos[0]
      y = pos[1]
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

    def get_moves(pos)
      right_angle_lines(pos[0], pos[1]) + diagonal_lines(pos[0], pos[1])
    end
  end

  class King < Piece
    attr_reader :symbol, :color
    attr_accessor :pos

    def initialize(color, pos = nil)
      super(color, pos)
      @symbol = color == :black ? "\u265a" : "\u2654"
    end

    def get_moves(pos)
      adjacent_cells(pos[0], pos[1])
    end
  end
end
