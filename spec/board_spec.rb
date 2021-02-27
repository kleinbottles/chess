# frozen_string_literal: true

require '../lib/board'

module Chess
  describe Board do
    context '#initialize' do
      subject(:board) { described_class.new }
      it "creates a grid" do
        expect(board.grid).to_not be_nil
      end
    end

    context '#move' do
      subject(:board) { described_class.new }
      before do
        board.starting_board
      end

      it 'returns false for illegal moves' do
        # we try to move a pawn 3 spaces
        expect(board.move([0, 1], [0, 4])).to eql false
      end

      context 'when a legal move is made' do

        it 'moves the piece to the given final position (pawn)' do
          starting_pos = [1, 1]
          ending_pos = [1, 2]
          piece = board.get_cell(1, 1).value
          board.move(starting_pos, ending_pos)
          expect(board.get_cell(1, 2).value).to eql piece
        end

        it 'moves the piece to the given final position (rook)' do
          starting_pos = [0, 7]
          ending_pos = [0, 5]
          piece = board.get_cell(0, 7).value
          board.set_cell(0, 6, nil)
          board.move(starting_pos, ending_pos)
          expect(board.get_cell(0, 5).value).to eql piece
        end

        it 'moves the piece to the given final position (bishop)' do
          starting_pos = [2, 0]
          ending_pos = [4, 2]
          piece = board.get_cell(2, 0).value
          board.set_cell(3, 1, nil)
          board.move(starting_pos, ending_pos)
          expect(board.get_cell(4, 2).value).to eql piece
        end
      end

      context 'when an illegal move is made' do
        it 'returns false' do
          starting_pos = [0, 7]
          ending_pos = [0, 5]
          expect(board.move(starting_pos, ending_pos)).to eql false
        end
      end

      context 'when a move ends in check' do
        it 'returns false' do
          board.set_cell(3, 5, Chess::Queen.new(:black, [3, 5]))
          board.set_cell(4, 6, nil)
          expect(board.move([4, 7], [4, 6])).to eql false
        end
      end
    end

    context '#check?' do
      subject(:board) { described_class.new }

      it 'returns true when the king is in check' do
        board.set_cell(0, 0, Rook.new(:black, [0, 0]))
        board.set_cell(0, 1, King.new(:white, [0, 1]))
        expect(board.check?(:white)).to eql true
      end

      it 'returns false when the king is not in check' do
        board.set_cell(4, 0, Rook.new(:black, [4, 0]))
        board.set_cell(0, 1, King.new(:white, [0, 1]))
        expect(board.check?(:white)).to eql false
      end
    end

    context '#checkmate?' do
      subject(:board) { described_class.new }

      it 'returns true when there are no ways out of check' do
        board.set_cell(2, 0, Rook.new(:black, [2, 0]))
        board.set_cell(0, 2, Rook.new(:black, [0, 2]))
        board.set_cell(2, 2, Bishop.new(:black, [2, 2]))
        board.set_cell(0, 0, King.new(:white, [0, 0]))
        expect(board.checkmate?(:white)).to eql true
      end

      it 'returns false when there is a way out of check' do
        board.set_cell(2, 0, Rook.new(:black, [2, 0]))
        board.set_cell(0, 2, Rook.new(:black, [0, 2]))
        board.set_cell(0, 0, King.new(:white, [0, 0]))
        expect(board.checkmate?(:white)).to eql false
      end
    end

  end
end
