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

    end

  end
end