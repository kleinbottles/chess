# frozen_string_literal: true

module Chess
  # The player class holds the name and color of the players.
  class Player
    attr_reader :name
    attr_accessor :color

    def initialize(name, color)
      @name = name
      @color = color
    end
  end
end
