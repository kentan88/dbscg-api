module DBSCG
  class Hand
    attr_reader :cards

    def initialize(opts = [])
      @cards = opts[:cards]
    end
  end
end

