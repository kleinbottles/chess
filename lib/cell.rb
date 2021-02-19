# frozen_string_literal: true

module Chess
  # The board consists of Cell objects, which can have a piece or be empty.
  class Cell
    attr_accessor :value

    def initialize(value = nil)
      @value = value
    end
  end
end
