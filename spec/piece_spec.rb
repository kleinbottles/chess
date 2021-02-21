# frozen_string_literal: true

require_relative '../lib/piece'

module Chess
  describe Rook do
    subject(:rook) { described_class.new(:black) }
    context '#get_moves' do
      pos = [0, 0]
      let(:moves) { rook.get_moves(pos) }

      it 'does not return the current position as a valid move' do
        expect(moves).not_to include pos
      end

      it 'does not return moves outside of the board' do
        expect(moves).not_to include [8,8]
      end

      it 'returns horizontal lines' do
        expect(moves).to include([0, 1], [0, 2], [0, 3])
      end

      it 'returns vertical lines' do
        expect(moves).to include([1, 0], [2, 0], [3, 0], [7, 0])
      end

      it 'does not return diagonal lines' do
        expect(moves).not_to include([1, 1], [2, 2],[3, 3])
      end
    end
  end

  describe Bishop do
    subject(:bishop) { described_class.new(:black) }
    context '#get_moves' do
      pos = [4, 4]
      let(:moves) { bishop.get_moves(pos) }

      it 'does not return current position as a move' do
        expect(moves).not_to include pos
      end

      it 'does not return horizontal lines' do
        expect(moves).not_to include([5, 4], [6, 4], [7, 4])
      end

      it 'returns diagonal lines' do
        expect(moves).to include([5, 5], [3, 3], [5, 3], [3, 5])
      end
    end
  end

  describe Queen do
    subject(:queen) { described_class.new(:black) }
    context '#get_moves' do
      pos = [4, 4]
      let(:moves) { queen.get_moves(pos) }

      it 'does not return current position as a move' do
        expect(moves).not_to include pos
      end

      it 'includes all immediately adjacent square' do
        expect(moves).to include([3, 4], [5, 4], [3, 3], [3, 4], [4, 3], [3, 5], [4, 5], [5, 5])
      end

      it 'does not include all space on the board' do
        expect(moves).not_to include [3, 2]
      end
    end
  end

  describe King do
    subject(:king) { described_class.new(:black) }
    context '#get_moves' do
      pos = [4, 4]
      let(:moves) { king.get_moves(pos) }

      it 'does not return current position as a move' do
        expect(moves).not_to include pos
      end

      it 'includes all immediately adjacent square' do
        expect(moves).to include([3, 4], [5, 4], [3, 3], [3, 4], [4, 3], [3, 5], [4, 5], [5, 5])
      end

      it 'does not include all space on the board' do
        expect(moves).not_to include [3, 2]
      end
    end
  end

  describe Pawn do
    subject(:white_pawn) { described_class.new(:white) }
    subject(:black_pawn) { described_class.new(:black) }

    context '#get_moves' do
      pos = [0, 1]
      let(:w_moves) { white_pawn.get_moves(pos) }
      let(:b_moves) { black_pawn.get_moves(pos) }

      it 'moves the white pawn 1 space forward (y + 1)' do
        expect(w_moves).to eql [0, 0]
      end

      it 'moves the black pawn 1 space forward (y - 1)' do
        expect(b_moves).to eql [0, 2]
      end
    end
  end

end
