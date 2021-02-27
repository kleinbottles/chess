# frozen_string_literal: true

require_relative 'cell'
require_relative 'piece'

module Chess
  # The board class creates the board object which tracks the game state.
  class Board
    attr_reader :grid, :history

    def initialize(grid = default_grid)
      @grid = grid
      @history = []
    end

    def get_cell(x, y)
      grid[y][x]
    end

    def set_cell(x, y, value)
      get_cell(x, y).value = value
    end

    def move(starting_pos, ending_pos, piece = get_piece(starting_pos))
      return false unless legal_move?(starting_pos, ending_pos) && clear_path(starting_pos, ending_pos)

      return false if ends_in_check?(ending_pos, starting_pos, piece.color)

      set_cell(ending_pos[0], ending_pos[1], piece)
      piece.pos = [ending_pos[0], ending_pos[1]]
      set_cell(starting_pos[0], starting_pos[1], nil)
      piece.move_count += 1
      history << [piece, starting_pos, ending_pos]
    end

    def castle_queenside(color)
      return false unless queenside_castling_available?(color)

      king_x = 4
      rook_x = 0
      y = color == :white ? 7 : 0
      king = get_piece([king_x, y])
      rook = get_piece([rook_x, y])
      set_cell(2, y, king)
      king.pos = [2, y]
      set_cell(3, y, rook)
      rook.pos = [3, y]
      set_cell(king_x, y, nil)
      set_cell(rook_x, y, nil)
    end

    def castle_kingside(color)
      return false unless kingside_castling_available?(color)

      king_x = 4
      rook_x = 7
      y = color == :white ? 7 : 0
      king = get_piece([king_x, y])
      rook = get_piece([rook_x, y])
      set_cell(6, y, king)
      king.pos = [6, y]
      set_cell(5, y, rook)
      rook.pos = [5, y]
      set_cell(king_x, y, nil)
      set_cell(rook_x, y, nil)
    end

    def starting_board
      set_cell(0, 0, Rook.new(:black, [0, 0]));   set_cell(7, 0, Rook.new(:black, [7, 0]));
      set_cell(1, 0, Knight.new(:black, [1, 0])); set_cell(6, 0, Knight.new(:black, [6, 0]));
      set_cell(2, 0, Bishop.new(:black, [2, 0])); set_cell(5, 0, Bishop.new(:black, [5, 0]));
      set_cell(3, 0, Queen.new(:black, [3, 0]));  set_cell(4, 0, King.new(:black, [4, 0]));
      8.times do |space|
        set_cell(space, 1, Pawn.new(:black, [space, 1]))
      end

      set_cell(0, 7, Rook.new(:white, [0, 7]));   set_cell(7, 7, Rook.new(:white, [7, 7]));
      set_cell(1, 7, Knight.new(:white, [1, 7])); set_cell(6, 7, Knight.new(:white, [6, 7]));
      set_cell(2, 7, Bishop.new(:white, [2, 7])); set_cell(5, 7, Bishop.new(:white, [5, 7]));
      set_cell(3, 7, Queen.new(:white, [3, 7]));  set_cell(4, 7, King.new(:white, [4, 7]));
      8.times do |space|
        set_cell(space, 6, Pawn.new(:white, [space, 6]))
      end
    end

    def display_board
      grid.each do |row|
        puts row.map { |cell| cell.value == nil ? '_' : cell.value.symbol }.join(' ')
      end
    end

    def check?(color)
      king_pos = get_king_pos(color)
      enemy_moves = get_all_legal_moves(opposite_color(color))
      return true if enemy_moves.include? king_pos
      false
    end

    def test_move(starting_pos, ending_pos)
      piece = get_piece(starting_pos)
      set_cell(ending_pos[0], ending_pos[1], piece)
      piece.pos = [ending_pos[0], ending_pos[1]]
      set_cell(starting_pos[0], starting_pos[1], nil)
    end

    def checkmate?(color, pieces = all_pieces(color))
      until pieces.empty?
        piece = pieces.pop
        piece_position = piece.pos
        moves = get_legal_moves(piece)
        until moves.empty?
          current_move = moves.pop
          return false unless ends_in_check?(current_move, piece_position, piece.color)
        end
      end
      true
    end

    def all_pieces(chosen_color)
      pieces = []
      8.times do |row|
        8.times do |column|
          if !get_cell(row, column).value.nil? && get_piece([row, column]).color == chosen_color
            pieces << get_piece([row, column])
          end
        end
      end
      pieces
    end

    def get_legal_moves(piece)
      potential_moves = piece.get_moves
      potential_moves.keep_if { |move| legal_move?(piece.pos, move) && clear_path(piece.pos, move) }
    end

    def get_all_legal_moves(color)
      pieces = all_pieces(color)
      pieces.reduce([]) { |i, piece| i + get_legal_moves(piece) }
    end

    private

    def default_grid
      Array.new(8) { Array.new(8) { Cell.new } }
    end

    def legal_move?(starting_pos, ending_pos)
      piece = get_piece(starting_pos)
      return true if piece.get_moves(starting_pos).include? ending_pos

      return true if valid_pawn_attack?(piece, ending_pos)

      false
    end

    def clear_path(starting_pos, ending_pos)
      piece = get_piece(starting_pos)
      # path is not clear if there is a piece on the ending position
      return false if get_piece(ending_pos) && get_piece(ending_pos).color == piece.color
      # the knight's path is clear if there is no piece on the final position
      return true if piece.instance_of?(Chess::Knight)

      # check horizontal lines
      if starting_pos[1] == ending_pos[1]
        check_horizontal(starting_pos[0], ending_pos[0], starting_pos[1])
      # check vertical lines
      elsif starting_pos[0] == ending_pos[0]
        check_vertical(starting_pos[1], ending_pos[1], starting_pos[0])
      # check diagonal lines
      elsif ((starting_pos[0] - ending_pos[0]) / (starting_pos[1] - ending_pos[1])) == 1
        check_diagonal_up(starting_pos, ending_pos)
      elsif ((starting_pos[0] - ending_pos[0]) / (starting_pos[1] - ending_pos[1])) == -1
        check_diagonal_down(starting_pos, ending_pos)
      end
    end

    def check_horizontal(starting_posx, ending_posx, y_value)
      max = [starting_posx, ending_posx].max - 1
      min = [starting_posx, ending_posx].min + 1

      max.downto(min).each do |space|
        return false unless get_cell(space, y_value).value.nil?
      end
      true
    end

    def check_vertical(starting_posy, ending_posy, x_value)
      max = [starting_posy, ending_posy].max - 1
      min = [starting_posy, ending_posy].min + 1

      max.downto(min).each do |space|
        return false unless get_cell(x_value, space).value.nil?
      end
      true
    end

    def check_diagonal_up(starting_pos, ending_pos)
      x1 = [starting_pos[0], ending_pos[0]].max - 1
      x2 = [starting_pos[0], ending_pos[0]].min
      y1 = [starting_pos[1], ending_pos[1]].max - 1
      y2 = [starting_pos[1], ending_pos[1]].min

      until x1 == x2 && y1 == y2
        return false unless get_cell(x1, y1).value.nil?

        x1 -= 1
        y1 -= 1
      end
      true
    end

    def check_diagonal_down(starting_pos, ending_pos)
      x1 = [starting_pos[0], ending_pos[0]].min + 1
      x2 = [starting_pos[0], ending_pos[0]].max
      y1 = [starting_pos[1], ending_pos[1]].max - 1
      y2 = [starting_pos[1], ending_pos[1]].min

      until (x1 == x2 && y1 == y2)
        return false unless get_cell(x1, y1).value.nil?

        x1 += 1
        y1 -= 1
      end
      true
    end

    def valid_pawn_attack?(piece, ending_pos)
      return false unless piece.instance_of?(Chess::Pawn)

      to_check = piece.diagonals_ahead(piece.pos[0], piece.pos[1])
      if to_check.any? do |diag|
           get_cell(diag[0], diag[1]).value&.color != piece.color &&
           get_cell(diag[0], diag[1]).value&.pos == ending_pos
         end
        true
      else
        false
      end
    end

    def get_piece(pos)
      get_cell(pos[0], pos[1]).value
    end

    def not_moved?(pos)
      return true if get_piece(pos).move_count.zero?

      false
    end

    def opposite_color(color)
      color == :black ? :white : :black
    end

    def get_king_pos(color)
      pieces = all_pieces(color)
      king = pieces.detect { |piece| piece.instance_of? Chess::King }
      king.pos
    end

    def kingside_castling_available?(color)
      king_x = 4
      rook_x = 7
      y = color == :white ? 7 : 0
      clear_path([(king_x + 1), y], [rook_x, y]) &&
        (not_moved?([king_x, y]) && not_moved?([rook_x, y])) &&
        !check?(color) &&
        [[(king_x + 1), y], [(king_x + 2), y]].each { |i| get_all_legal_moves(opposite_color(color)).none? i }
    end

    def queenside_castling_available?(color)
      king_x = 4
      rook_x = 0
      y = color == :white ? 7 : 0
      clear_path([king_x, y], [(rook_x + 1), y]) &&
        (not_moved?([king_x, y]) && not_moved?([rook_x, y])) &&
        !check?(color) &&
        [[(king_x - 1), y], [(king_x - 2), y]].each { |i| get_all_legal_moves(opposite_color(color)).none? i }
    end

    def ends_in_check?(move_to_check, current_pos, color)
      # the 'test move' might have a piece on it that we could delete, so we need to restore it
      # if there is nothing there, the value will remain nil
      to_revert = get_cell(move_to_check[0], move_to_check[1]).value
      test_move(current_pos, move_to_check)
      in_check = check?(color)
      test_move(move_to_check, current_pos)
      set_cell(move_to_check[0], move_to_check[1], to_revert)
      in_check
    end
  end
end
