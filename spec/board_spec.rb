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
  end
end
